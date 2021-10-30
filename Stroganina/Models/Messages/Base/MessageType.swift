//
//  MessageType.swift
//  EasyMessenger WatchKit Extension
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
}

final class MessageWrapper: Identifiable, ObservableObject {
    let id: Message.ID
    @Published var type: MessageType

    init(type: MessageType) {
        self.id = type.id
        self.type = type
    }
}
