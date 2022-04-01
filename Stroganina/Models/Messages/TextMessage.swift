//
//  TextMessage.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation

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

extension TextMessage {
    static func makeWeb(base: Message, text: String) -> MessageType? {
        if URL(string: text) != nil, text.hasPrefix("https://") {
            return .web(TextMessage(base: base, text: text))
        }
        return nil
    }
}
