//
//  Message+Raw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import Foundation

extension Message {
    convenience init(_ raw: MessageRaw) {
        self.init(
            id: raw.messageId,
            date: Date(timeIntervalSince1970: TimeInterval(raw.date)),
            user: User(raw.user),
            isOutgoing: raw.user.isSelf,
            showSenders: true,
            chatId: raw.chatId
        )
    }
}
