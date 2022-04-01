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
    var date: Date
    var isOutgoing: Bool
    var remoteId: MessageIdentifier.ID?
    let chatId: Chat.ID
    var sender: String? {
        (!isOutgoing) ? user?.name : nil
    }

    @Published var status: Status
    @Published var user: User?

    init(
        id: ID,
        date: Date,
        user: User?,
        isOutgoing: Bool,
        chatId: Chat.ID,
        remoteId: MessageIdentifier.ID?,
        status: Status
    ) {
        self.id = id
        self.date = date
        self.user = user
        self.isOutgoing = isOutgoing
        self.chatId = chatId
        self.status = status
        self.remoteId = remoteId
    }
    
    init(
        id: ID,
        date: Date,
        chatId: Chat.ID,
        remoteId: MessageIdentifier.ID?,
        state: Status
    ) {
        self.id = id
        self.date = date
        self.user = nil
        self.isOutgoing = true
        self.chatId = chatId
        self.status = state
        self.remoteId = remoteId
    }

    init(_ other: Message) {
        id = other.id
        date = other.date
        user = other.user
        isOutgoing = other.isOutgoing
        chatId = other.chatId
        status = other.status
        remoteId = other.remoteId
    }
    
    func update(_ other: Message) {
        DispatchQueue.main.async {
            self.date = other.date
            self.user = other.user
            self.isOutgoing = other.isOutgoing
            self.status = other.status
            self.remoteId = other.remoteId
        }
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
    
    enum Status: CaseIterable {
        case awaiting
        case failed
        case sent
        case read
        case unknown
    }

    static func mock(
        _ options: MockOptions = .default,
        id: Message.ID = .remote(id: 10),
        status: Status = .sent
    ) -> Message {
        Message(
            id: id,
            date: Date(),
            user: options.contains(.user) ? .mock : nil,
            isOutgoing: options.contains(.isOutgoing),
            chatId: 1,
            remoteId: nil,
            status: status
        )
    }
}
