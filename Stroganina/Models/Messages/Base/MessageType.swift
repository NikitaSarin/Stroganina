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

    var id: Message.ID {
        base.id
    }

    var base: Message {
        switch self {
        case let .text(message): return message
        case let .emoji(message): return message
        case let .service(message): return message
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
        if text.isSingleEmoji {
            self = .emoji(TextMessage(base: base, text: text))
        } else {
            self = .text(TextMessage(base: base, text: text))
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
