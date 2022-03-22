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
    func load(_ handler: @escaping (([ChatItem]) -> Void))
    func send(text: String, completion: @escaping BoolClosure)
    func useItem(_ item: ChatItem)
}

final class ChatService: ChatServiceProtocol {
    private var updateHandler: (([ChatItem]) -> Void)?

    private let queue = DispatchQueue(label: "storage.queue")
    private var pools: [MessagesPool] = []
    
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
    
    func useItem(_ item: ChatItem) {
        self.queue.async {
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
    
    func send(text: String, completion: @escaping BoolClosure) {
        let function = NewMessage(
            type: .text,
            content: text,
            chatId: chatId
        )
        let container = MessageContainer(
            provider: .init(
                makeMessageType: { [chatId] identifier in
                    .makeTextSkeletonType(identifier: identifier, content: text, chatId: chatId)
                }
            ),
            identifier: nil
        )
        self.queue.async {
            MessagesPool(containers: [container]).flatMap { self.pools.append($0) }
            self.didUpdate()
        }
        api.perform(function) { [weak self] result in
            switch result {
            case .success(let response):
                container.provider = .init(response)
                self?.queue.async {
                    self?.sendedMessage(container)
                    DispatchQueue.main.async {
                        self?.updateCenter.sendNotification(.newMessage(container.messageWrapper))
                    }
                }
                completion(true)
            case let .failure(error):
                print(error)
                completion(false)
            }
        }
    }
    
    func load(_ handler: @escaping (([ChatItem]) -> Void)) {
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
            self.update(raws.map { .init(provider: .init($0), identifier: nil) })
        }
    }
    
    private func addNewMessage(_ message: MessageContainer) {
        queue.async {
            guard self.bottomLoaded else {
                self.update([message])
                return
            }
            if let pool = self.pools.last(where: { $0.containers.last?.remoteID != nil }) {
                pool.containers.append(message)
                self.didUpdate()
            } else {
                self.update([message])
            }
        }
    }
    
    private func didUpdate() {
        var items = [ChatItem]()

        for pool in pools {
            if pool.containers.first?.remoteID == nil {
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
            if let first = pool.containers.first, first.backID == nil, let id = first.remoteID {
                if !(items.isEmpty && self.topLoaded) {
                    items.append(.empty(id: .init(id), reverse: false))
                }
            }
            let messages = pool.containers.map { ChatItem.message(message: $0.messageWrapper) }
            items.append(contentsOf: messages)
            if let last = pool.containers.last, last.nextID == nil, let id = last.remoteID {
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
    
    private func sendedMessage(_ message: MessageContainer) {
        pools.removeAll(where: { $0.containers.contains(where: { $0.identifier == message.identifier })})
    }

    private func update(_ inputs: [MessageContainer]) {
        guard !inputs.isEmpty else {
            return
        }
        defer {
            didUpdate()
        }
        var messages = inputs.sorted(by: { $0.actualIdentifier < $1.actualIdentifier })
        
        let index = (pools.firstIndex(where: { $0.minID >= messages[0].actualIdentifier }))
        
        guard let index = index else {
            MessagesPool(containers: messages).flatMap { pools.append($0) }
            return
        }
        
        var result = [MessageContainer]()
        while index < pools.count, !messages.isEmpty, pools[index].minID <= messages[messages.count - 1].actualIdentifier {
            let pool = pools[index]
            pools.remove(at: index)
            
            for container in pool.containers {
                while !messages.isEmpty && messages[0].actualIdentifier < container.actualIdentifier {
                    result.append(messages[0])
                    messages.removeFirst()
                }
                if !messages.isEmpty && container.actualIdentifier < messages[0].actualIdentifier {
                    result.append(container)
                } else if !messages.isEmpty && container.actualIdentifier == messages[0].actualIdentifier {
                    container.provider = messages[0].provider
                    result.append(container)
                    messages.removeFirst()
                } else if messages.isEmpty {
                    result.append(container)
                }
            }
        }
        while !messages.isEmpty {
            result.append(messages[0])
            messages.removeFirst()
        }
        if let newPools = MessagesPool(containers: result)?.separate(max: padgeSize) {
            pools.insert(contentsOf: newPools, at: index)
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
                        .init(
                            provider: .init(
                                remoteID: message.base.remoteId,
                                makeMessageType:  { _ in message.type }
                            ),
                            identifier: message.id
                        )
                    )
                }
            case .closeConnect:
                outOfSync()
            default:
                break
            }
        }
    }
}

extension ChatService {
    struct Mock: ChatServiceProtocol {
        func useItem(_ item: ChatItem) { }
        func load(_ handler: @escaping (([ChatItem]) -> Void)) { }
        func send(text: String, completion: @escaping BoolClosure) {}
    }
}
