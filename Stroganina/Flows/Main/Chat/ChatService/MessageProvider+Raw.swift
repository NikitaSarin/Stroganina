//
//  MessageProvider+Raw.swift
//  Stroganina
//
//  Created by Alex Shipin on 22.03.2022.
//

import NetworkApi

extension ChatService.MessageProvider {
    init(_ raw: Raw.Message) {
        self.remoteID = raw.messageId
        self.makeMessageType = { .init(raw, identifier: $0) }
    }
}
