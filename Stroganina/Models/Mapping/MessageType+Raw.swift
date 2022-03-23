//
//  MessageType+Raw.swift
//  Stroganina
//
//  Created by Alex Shipin on 22.03.2022.
//

import NetworkApi

extension MessageType {
    init(
        _ raw: Raw.Message,
        identifier: MessageIdentifier?
    ) {
        let base = Message(raw, identifier: identifier.generate(raw.messageId))
        switch raw.type {
        case .text:
            self = Self.makeTextBase(base, text: raw.content)
        case .service:
            self = .service(TextMessage(base: base, text: raw.content))
        case .unknown:
            self = .service(TextMessage(base: base, text: "Unknown message type"))
        case .webURL:
            self = .webContent(TextMessage(base: base, text: raw.content))
        case .webContent:
            self = .web(TextMessage(base: base, text: raw.content))
        }
    }
}



