//
//  ChatService.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation
import NetworkApi
import SwiftUI

protocol ChatServiceProtocol {
    func load(_ handler: @escaping (([HistoryItem]) -> Void))
    func send(text: String)
    func viewDidShow(_ item: HistoryItem)
}

final class ChatService: ChatServiceProtocol {
    private var updateHandler: (([HistoryItem]) -> Void)?

    private let queue = DispatchQueue(label: "storage.queue")
    private var pages: [MessagesPage] = []

    private let api: Networking
    private let chatId: Chat.ID
    private let updateCenter: UpdateCenter
    private let padgeSize = 30

    private var topLoaded: Bool = false
    private var bottomLoaded: Bool = false

    private var loading = Set<String>()

    init(
        chatId: Chat.ID,
        api: Networking,
        updateCenter: UpdateCenter
    ) {
        self.chatId = chatId
        self.api = api
        self.updateCenter = updateCenter
        
        updateCenter.addListener(self)
    }
    
    func viewDidShow(_ item: HistoryItem) {
        queue.async {
            switch item {
            case .new(let id, let reverse):
                if !self.loading.contains(item.id) {
                    self.loading.insert(item.id)
                    self.fetch(from: id, reverse: reverse) {
                        self.queue.async {
                            self.loading.remove(item.id)
                        }
                    }
                }
            case .empty(let id, let reverse):
                if !self.loading.contains(item.id) {
                    self.loading.insert(item.id)
                    self.fetch(from: id, reverse: reverse) {
                        self.queue.async {
                            self.loading.remove(item.id)
                        }
                    }
                }
            case .message:
                break
            }
        }
    }

    func send(text: String) {
        let function = NewMessage(
            type: .text,
            content: text,
            chatId: chatId
        )
        let message = MessageNode(
            MessageType(
                text: text,
                chatId: chatId
            ).wrapped()
        )
        queue.async {
            MessagesPage(messages: [message]).flatMap { self.pages.append($0) }
            self.didUpdate()
        }
        api.perform(function) { [weak self] result in
            switch result {
            case .success(let response):
                message.messageType.base.update(.init(response, identifier: message.identifier))
                self?.queue.async {
                    self?.sendedMessage(message)
                    DispatchQueue.main.async {
                        self?.updateCenter.sendNotification(.newMessage(message.messageWrapper))
                    }
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    message.messageType.base.status = .failed
                }
                print(error)
            }
        }
    }

    func load(_ handler: @escaping (([HistoryItem]) -> Void)) {
        queue.async {
            self.updateHandler = handler
            self.didUpdate()
        }
    }

    private func outOfSync() {

        queue.async {
            self.bottomLoaded = false
            self.didUpdate()
        }
    }
    
    private func fetch(from messageId: NetworkApi.ID?, reverse: Bool = false, completion: @escaping () -> Void) {
        let function = GetMessages(
            chatId: chatId,
            limit: padgeSize,
            lastMessageId: messageId,
            reverse: reverse
        )
        api.perform(function) { [weak self, padgeSize] result in
            switch result {
            case let .success(response):
                self?.queue.async {
                    if response.messages.count < padgeSize {
                        if reverse {
                            self?.bottomLoaded = true
                        } else {
                            self?.topLoaded = true
                        }
                    }
                    if messageId == nil {
                        if reverse {
                            self?.topLoaded = true
                        } else {
                            self?.bottomLoaded = true
                        }
                    }
                    self?.update(raws: response.messages)
                    completion()
                }
            case let .failure(error):
                print(error)
                self?.queue.async {
                    completion()
                }
            }
        }
    }

    private func update(raws: [Raw.Message]) {
        queue.async {
            self.update(raws.map { MessageNode(MessageWrapper($0, identifier: nil)) })
        }
    }

    private func addNewMessage(_ message: MessageNode) {
        queue.async {
            guard self.bottomLoaded else {
                self.update([message])
                return
            }
            if let page = self.pages.last(where: { $0.messages.last?.remoteID != nil }) {
                page.messages.append(message)
                self.didUpdate()
            } else {
                self.update([message])
            }
        }
    }

    private func didUpdate() {
        var items = [HistoryItem]()

        for page in pages {
            if page.messages.first?.remoteID == nil {
                if case let .empty(id, reverse) = items.last {
                    items.removeLast()
                    if !bottomLoaded {
                        items.append(.new(id: id, reverse: reverse))
                    }
                }
                if items.isEmpty {
                    items.append(.new(id: nil, reverse: false))
                }
            }
            if let first = page.messages.first, first.backID == nil, let id = first.remoteID {
                if !(items.isEmpty && self.topLoaded) {
                    items.append(.empty(id: .init(id), reverse: false))
                }
            }
            let messages = page.messages.map { HistoryItem.message(message: $0.messageWrapper) }
            items.append(contentsOf: messages)
            if let last = page.messages.last, last.nextID == nil, let id = last.remoteID {
                items.append(.empty(id: .init(id), reverse: true))
            }
        }
        if case .empty(let id, _) = items.last {
            items.removeLast()
            if !bottomLoaded {
                items.append(.new(id: id, reverse: true))
            }
        }
        if items.isEmpty {
            items.append(.new(id: nil, reverse: false))
        }

        self.updateHandler?(items.reversed())
    }

    private func sendedMessage(_ message: MessageNode) {
        pages.removeAll(where: { $0.messages.contains(where: { $0.identifier == message.identifier })})
    }

    private func update(_ inputs: [MessageNode]) {
        guard !inputs.isEmpty else {
            return
        }
        defer {
            didUpdate()
        }
        var messages = inputs.sorted(by: { $0.actualIdentifier < $1.actualIdentifier })
        let index = (pages.firstIndex(where: { $0.maxID >= messages[0].actualIdentifier }))
        guard let index = index else {
            MessagesPage(messages: messages).flatMap { pages.append($0) }
            return
        }

        var result = [MessageNode]()
        while index < pages.count, !messages.isEmpty, pages[index].minID <= messages[messages.count - 1].actualIdentifier {
            let page = pages[index]
            pages.remove(at: index)

            for message in page.messages {
                while !messages.isEmpty && messages[0].actualIdentifier < message.actualIdentifier {
                    result.append(messages[0])
                    messages.removeFirst()
                }
                if !messages.isEmpty && message.actualIdentifier < messages[0].actualIdentifier {
                    result.append(message)
                } else if !messages.isEmpty && message.actualIdentifier == messages[0].actualIdentifier {
                    message.messageType.base.update(messages[0].messageType.base)
                    result.append(message)
                    messages.removeFirst()
                } else if messages.isEmpty {
                    result.append(message)
                }
            }
        }
        while !messages.isEmpty {
            result.append(messages[0])
            messages.removeFirst()
        }
        if let newPages = MessagesPage(messages: result)?.separate(max: padgeSize) {
            pages.insert(contentsOf: newPages, at: index)
        }
    }
}

extension ChatService: Listener {
    func update(_ notifications: [Notification]) {
        for notification in notifications {
            switch notification {
            case .newMessage(let message):
                if message.base.chatId == chatId {
                    addNewMessage(
                        MessageNode(message)
                    )
                }
            case .reconnected:
                outOfSync()
            default:
                break
            }
        }
    }
}

extension ChatService {
    struct Mock: ChatServiceProtocol {
        func viewDidShow(_ item: HistoryItem) { }
        func load(_ handler: @escaping (([HistoryItem]) -> Void)) { }
        func send(text: String) {}
    }
}
