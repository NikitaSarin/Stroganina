//
//  Message+Raw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import Foundation
import NetworkApi

extension Message {
    convenience init(
        _ raw: Raw.Message,
        identifier: MessageIdentifier
    ) {
        self.init(
            id: identifier,
            date: Date(timeIntervalSince1970: TimeInterval(raw.date)),
            user: User(raw.user),
            isOutgoing: raw.user.isSelf,
            chatId: raw.chatId,
            remoteId: raw.messageId,
            state: .init(raw.state?.value)
        )
    }
}

extension Message.MessageState {
    init(_ state: Raw.MessageState?) {
        switch state {
        case .sended:
            self = .sended
        case .none:
            self = .sended
        case .failed:
            self = .failed
        case .read:
            self = .read
        }
    }
}
