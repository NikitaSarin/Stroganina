//
//  Message.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import SwiftUI

class Message: Identifiable, ObservableObject {

    typealias ID = MessageIdentifier

    let id: MessageIdentifier
    let date: Date
    var isOutgoing: Bool
    var state: MessageState
    var remoteId: MessageIdentifier.ID?
    let chatId: Chat.ID
    var sender: String? {
        (!isOutgoing) ? user?.name : nil
    }

    @Published var user: User?

    init(
        id: ID,
        date: Date,
        user: User?,
        isOutgoing: Bool,
        chatId: Chat.ID,
        remoteId: MessageIdentifier.ID?,
        state: MessageState
    ) {
        self.id = id
        self.date = date
        self.user = user
        self.isOutgoing = isOutgoing
        self.chatId = chatId
        self.state = state
        self.remoteId = remoteId
    }
    
    init(
        id: ID,
        date: Date,
        chatId: Chat.ID,
        remoteId: MessageIdentifier.ID?,
        state: MessageState
    ) {
        self.id = id
        self.date = date
        self.user = nil
        self.isOutgoing = true
        self.chatId = chatId
        self.state = state
        self.remoteId = remoteId
    }

    init(_ other: Message) {
        id = other.id
        date = other.date
        user = other.user
        isOutgoing = other.isOutgoing
        chatId = other.chatId
        state = other.state
        remoteId = other.remoteId
    }
}

extension Message {

    struct MockOptions: OptionSet {
        let rawValue: Int

        static let user = MockOptions(rawValue: 1 << 0)
        static let isOutgoing = MockOptions(rawValue: 1 << 1)
        static let reply = MockOptions(rawValue: 1 << 3)
        static let forward = MockOptions(rawValue: 1 << 4)
        static let `default`: MockOptions = [.user]
        static let empty: MockOptions = []
    }
    
    enum MessageState {
        case watingSend
        case sended
        case failed
        case read
        case unknown
    }

    static func mock(_ options: MockOptions = .default, id: Message.ID = .remote(id: 10), state: MessageState = .sended) -> Message {
        Message(
            id: id,
            date: Date(),
            user: options.contains(.user) ? .mock : nil,
            isOutgoing: options.contains(.isOutgoing),
            chatId: 1,
            remoteId: nil,
            state: .sended
        )
    }
}
