//
//  TelegramMessage.swift
//  Stroganina
//
//  Created by Alex Shipin on 01.04.2022.
//

import Foundation

final class TelegramMessage: Message {

    let link: String

    init(
        base: Message,
        link: String
    ) {
        self.link = link
        super.init(base)
    }
}

extension TelegramMessage {
    static let mock = TelegramMessage(base: .mock(), link: "https://t.me/ru2ch_news/38783")
}

extension TelegramMessage {
    static func make(base: Message, text: String) -> MessageType? {
        let tgPrefix = "https://t.me/"
        if text.hasPrefix(tgPrefix) {
            return .telegram(TelegramMessage(base: base, link: text.split(separator: "?").map(String.init)[0]))
        }
        return nil
    }
}
