//
//  MessageType+Raw.swift
//  Stroganina
//
//  Created by Alex Shipin on 22.03.2022.
//

import NetworkApi

extension MessageType {
    init(_ raw: Raw.Message, identifier: MessageIdentifier?) {
        let base = Message(raw, identifier: identifier.generate(raw.messageId.flatMap { .init($0) }))
        switch raw.type {
        case .text:
            if raw.content.isSingleEmoji {
                self = .emoji(TextMessage(base: base, text: raw.content))
            } else {
                self = .text(TextMessage(base: base, text: raw.content))
            }
        case .service:
            self = .service(TextMessage(base: base, text: raw.content))
        case .unknown:
            self = .service(TextMessage(base: base, text: "Unknown message type"))
        }
    }
}



