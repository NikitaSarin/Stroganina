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
    static let mock = TextMessage(base: .mock(), text: "Hello")
}
