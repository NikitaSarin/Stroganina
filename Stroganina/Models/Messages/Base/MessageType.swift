//
//  MessageType.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 24.05.2021.
//

import Combine

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
