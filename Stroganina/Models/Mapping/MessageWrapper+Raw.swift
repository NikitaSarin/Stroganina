//
//  MessageWrapper+Raw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import NetworkApi

extension MessageWrapper {
    convenience init(_ raw: Raw.Message) {
        let base = Message(raw)
        let type: MessageType
        switch raw.type {
        case .text:
            if raw.content.isSingleEmoji {
                type = .emoji(TextMessage(base: base, text: raw.content))
            } else {
                type = .text(TextMessage(base: base, text: raw.content))
            }
        case .service:
            type = .service(TextMessage(base: base, text: raw.content))
        case .unknown:
            type = .service(TextMessage(base: base, text: "Unknown message type"))
        }
        self.init(type: type)
    }
}
