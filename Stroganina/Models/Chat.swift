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

    @Published var unreadCount: Int
    @Published var lastMessage: TextMessage?

    init(
        id: ID,
        title: String,
        showSenders: Bool,
        unreadCount: Int,
        lastMessage: TextMessage?
    ) {
        self.id = id
        self.title = title
        self.showSenders = showSenders
        self.unreadCount = unreadCount
        self.lastMessage = lastMessage
    }
}

extension Chat {
    static let mock = Chat(
        id: 1,
        title: "Contest",
        showSenders: true,
        unreadCount: 2,
        lastMessage: .mock
    )
}
