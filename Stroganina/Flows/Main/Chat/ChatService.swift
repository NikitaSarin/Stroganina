//
//  ChatService.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation

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

    private var messages = [MessageWrapper]()

    init(
        chatId: Chat.ID,
        api: Networking
    ) {
        self.chatId = chatId
        self.api = api
    }

    func start() {
        self.timer = Timer.scheduledTimer(
            withTimeInterval: 5,
            repeats: true,
            block: { [weak self] _ in
            self?.reload()
        })
    }

    func send(text: String, completion: @escaping BoolClosure) {
        let function = NewMessage(
            type: .text,
            content: text,
            chatId: chatId
        )
        api.perform(function) { [weak self] result in
            switch result {
            case .success:
                completion(true)
                self?.reload()
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
                    MessageWrapper(response: $0)
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

    private func notifyDelegate() {
        delegate?.didChange(messages: messages)
    }
}

enum RawMessageType: String, Codable {
    case text = "TEXT"
    case service = "SYSTEM_TEXT"
    case unknown
}

private extension MessageWrapper {

    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    convenience init(response: GetMessages.Response.Message) {
        let date = Date(timeIntervalSince1970: TimeInterval(response.date))
        let user = User(id: response.user.userId, name: response.user.name)
        let base = Message(
            id: response.messageId,
            time: Self.formatter.string(from: date),
            user: user,
            isOutgoing: response.user.isSelf,
            showSenders: true,
            chatId: response.chatId
        )
        let rawType = RawMessageType(rawValue: response.type) ?? .unknown
        let type: MessageType
        switch rawType {
        case .text:
            if response.content.containsOnlyEmoji, response.content.count < 4 {
                type = .emoji(TextMessage(base: base, text: response.content))
            } else {
                type = .text(TextMessage(base: base, text: response.content))
            }

        case .service:
            type = .service(TextMessage(base: base, text: response.content))
        case .unknown:
            type = .service(TextMessage(base: base, text: "Unknown message type"))
        }
        self.init(type: type)
    }
}
