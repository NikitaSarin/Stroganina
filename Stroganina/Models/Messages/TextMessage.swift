//
//  TextMessage.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

final class TextMessage: Message {

    let text: String

    init(
        base: Message,
        text: String
    ) {
        self.text = text
        super.init(base)
    }
}

extension TextMessage {
    static let mock = TextMessage(base: .mock(), text: "Hello\nWorld")
}


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
