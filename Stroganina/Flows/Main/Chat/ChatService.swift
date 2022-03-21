//
//  ChatService.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation
import NetworkApi

protocol ChatServiceDelegate: AnyObject {
    func didChange(messages: [MessageWrapper])
}

protocol ChatServiceProtocol {
    var allMessagesFetched: Bool { get }
    var delegate: ChatServiceDelegate? { get set }
    func start()
    func fetch(from messageId: Message.ID?)
    func send(text: String, completion: @escaping BoolClosure)
}

final class ChatService: ChatServiceProtocol {

    var allMessagesFetched: Bool = true
    weak var delegate: ChatServiceDelegate?

    private let api: Networking
    private var timer: Timer?
    private let chatId: Chat.ID
    private let updateCenter: UpdateCenter

    private var messages = [MessageWrapper]()

    init(
        chatId: Chat.ID,
        api: Networking,
        updateCenter: UpdateCenter
    ) {
        self.chatId = chatId
        self.api = api
        self.updateCenter = updateCenter
        updateCenter.addListener(self)
        self.reload()
    }

    func start() {
    }

    func send(text: String, completion: @escaping BoolClosure) {
        let function = NewMessage(
            type: .text,
            content: text,
            chatId: chatId
        )
        api.perform(function) { [updateCenter] result in
            switch result {
            case .success(let response):
                let message = MessageWrapper(response)
                updateCenter.sendNotification(.newMessage(message))
                completion(true)
            case let .failure(error):
                print(error)
                completion(false)
            }
        }
    }

    func fetch(from messageId: Message.ID?) {
        let function = GetMessages(
            chatId: chatId,
            limit: 99,
            lastMessageId: nil,
            reverse: false
        )
        api.perform(function) { [weak self] result in
            switch result {
            case let .success(response):
                self?.messages = response.messages.map {
                    MessageWrapper($0)
                }
                self?.notifyDelegate()
            case let .failure(error):
                print(error)
            }
        }
    }

    private func reload() {
        fetch(from: messages.first?.id)
    }
    
    private func reloadLast() {
        fetch(from: nil)
    }

    private func notifyDelegate() {
        delegate?.didChange(messages: messages)
    }
}

extension ChatService: Listener {
    func update(_ notifications: [Notification]) {
        var isNeedUpdate: Bool = false

        for notification in notifications {
            switch notification {
            case .newMessage(let message):
                if message.base.chatId == chatId {
                    messages.insert(message, at: 0)
                    isNeedUpdate = true
                }
            case .closeConnect:
                reloadLast()
            default:
                break
            }
        }
        
        if isNeedUpdate {
            self.notifyDelegate()
        }
    }
}

extension ChatService {
    struct Mock: ChatServiceProtocol {
        var allMessagesFetched = true
        var delegate: ChatServiceDelegate?

        func start() {}
        func send(text: String, completion: @escaping BoolClosure) {}
        func fetch(from messageId: Message.ID?) {
            let messages: [MessageWrapper] = (0...20).map { index in
                MessageWrapper(
                    type: .text(.init(base: .mock(id: index), text: "Hello"))
                )
            }
            delegate?.didChange(messages: messages)
        }
    }
}
