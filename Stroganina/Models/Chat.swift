//
//  Chat.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import UIKit

final class Chat: Identifiable, ObservableObject {

    typealias ID = UInt

    let id: ID
    var title: String
    var showSenders: Bool

    @Published var users: [User]?
    @Published var unreadCount: Int
    @Published var lastMessage: MessageWrapper? {
        willSet {
            objectWillChange.send()
        }
    }

    init(
        id: ID,
        title: String,
        showSenders: Bool,
        unreadCount: Int,
        lastMessage: MessageWrapper?
    ) {
        self.id = id
        self.title = title
        self.showSenders = showSenders
        self.unreadCount = unreadCount
        self.lastMessage = lastMessage
    }
}

extension Chat: Hashable {
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Chat {
    static let mock = Chat(
        id: 1,
        title: "Stroganina Club",
        showSenders: true,
        unreadCount: 2,
        lastMessage: .mock
    )
}
