//
//  MessageType.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 24.05.2021.
//

import Combine
import Foundation

enum MessageType: Identifiable {

    case text(TextMessage)
    case emoji(TextMessage)
    case service(TextMessage)
    case web(TextMessage)
    case webContent(TextMessage)
    case telegram(TelegramMessage)

    var id: Message.ID {
        base.id
    }

    var base: Message {
        switch self {
        case let .text(message): return message
        case let .emoji(message): return message
        case let .service(message): return message
        case let .web(message): return message
        case let .webContent(message): return message
        case let .telegram(message): return message
        }
    }

    var description: String {
        switch self {
        case let .text(message):
            return message.text
        case let .emoji(message):
            return message.text
        case let .service(message):
            return message.text
        case let .web(message):
            return message.text
        case .webContent:
            return "***HTML***"
        case .telegram:
            return "***Telegramm message***"
        }
    }

    init(
        text: String,
        chatId: Chat.ID
    ) {
        let identifier = MessageIdentifier.make(with: nil)
        let base = Message(
            id: identifier,
            date: Date(),
            chatId: chatId,
            remoteId: nil,
            state: .awaiting
        )
        self = Self.makeTextBase(base, text: text)
    }

    static func makeTextBase(_ base: Message, text: String) -> Self {
        let tgPrefix = "https://t.me/"
        if text.hasPrefix(tgPrefix) {
            return .telegram(TelegramMessage(base: base, link: text.split(separator: "?").map(String.init)[0]))
        } else if URL(string: text) != nil, text.hasPrefix("https://") {
            return .web(TextMessage(base: base, text: text))
        } else if text.isSingleEmoji {
            return .emoji(TextMessage(base: base, text: text))
        } else {
            return .text(TextMessage(base: base, text: text))
        }
    }

    func wrapped() -> MessageWrapper {
        MessageWrapper(type: self)
    }
}

final class MessageWrapper: Identifiable, ObservableObject {
    let id: Message.ID
    @Published var type: MessageType

    init(type: MessageType) {
        self.id = type.id
        self.type = type
    }
    
    var base: Message {
        type.base
    }
}

extension MessageWrapper {
    static var mock: MessageWrapper {
        MessageWrapper(type: .text(.mock))
    }
}
