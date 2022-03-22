//
//  Chat+Raw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import NetworkApi

extension Chat {
    convenience init(_ raw: Raw.Chat) {
        self.init(
            id: raw.chatId,
            title: raw.name,
            showSenders: raw.type != .personal,
            unreadCount: raw.notReadCount ?? 0,
            chatType: .init(raw.type),
            lastMessage: raw.message.flatMap( { MessageWrapper($0, identifier: .make(with: $0.messageId)) })
        )
    }
}

extension Chat.ChatType {
    init(_ raw: Raw.Chat.ChatType) {
        switch raw {
        case .personal:
            self = .personal
        case .group:
            self = .group
        case .unknown:
            self = .unknown
        }
    }
}
