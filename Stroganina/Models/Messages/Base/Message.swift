//
//  Message.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import SwiftUI

class Message: Identifiable, ObservableObject {

    typealias ID = UInt

    let id: ID
    let time: String
    var isOutgoing: Bool
    var showSenders: Bool
    let date: Date
    let chatId: Chat.ID
    var sender: String? {
        (showSenders && !isOutgoing) ? user?.name : nil
    }

    @Published var user: User?

    init(
        id: ID,
        time: String,
        user: User?,
        isOutgoing: Bool,
        showSenders: Bool,
        date: Date,
        chatId: Chat.ID
    ) {
        self.id = id
        self.time = time
        self.user = user
        self.isOutgoing = isOutgoing
        self.showSenders = showSenders
        self.date = date
        self.chatId = chatId
    }

    init(_ other: Message) {
        id = other.id
        time = other.time
        user = other.user
        isOutgoing = other.isOutgoing
        showSenders = other.showSenders
        date = other.date
        chatId = other.chatId
    }
}

extension Message {

    struct MockOptions: OptionSet {
        let rawValue: Int

        static let user = MockOptions(rawValue: 1 << 0)
        static let isOutgoing = MockOptions(rawValue: 1 << 1)
        static let showSenders = MockOptions(rawValue: 1 << 2)
        static let reply = MockOptions(rawValue: 1 << 3)
        static let forward = MockOptions(rawValue: 1 << 4)
        static let `default`: MockOptions = [.user, .showSenders]
        static let empty: MockOptions = []
    }

    static func mock(_ options: MockOptions = .default, id: Message.ID = 1) -> Message {
        Message(
            id: id,
            time: "12:34",
            user: options.contains(.user) ? .mock : nil,
            isOutgoing: options.contains(.isOutgoing),
            showSenders: options.contains(.showSenders),
            date: Date(),
            chatId: 1
        )
    }
}
