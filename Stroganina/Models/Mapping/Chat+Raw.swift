//
//  Chat+Raw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import Foundation

extension Chat {
    convenience init(_ raw: ChatRaw) {
        self.init(
            id: raw.chatId,
            title: raw.name,
            showSenders: raw.isPersonal == false,
            unreadCount: raw.notReadCount ?? 0,
            lastMessage: raw.message.flatMap(MessageWrapper.init)
        )
    }
}
