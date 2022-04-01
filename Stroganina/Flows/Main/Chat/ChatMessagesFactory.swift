//
//  ChatMessagesFactory.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import SwiftUI

private extension MessageType {
    var bubbleStyle: BubbleStyle {
        switch self {
        case .text:
            return .plain
        case .emoji:
            return .transparent
        case .service:
            return .service
        case .web:
            return .plain
        case .webContent:
            return .plain
        case .telegram:
            return .plain
        }
    }
}

struct ChatMessagesFactory {

    func bubble(for type: MessageType, openMessageBlock: @escaping VoidClosure) -> some View {
        Bubble(
            message: type.base,
            style: type.bubbleStyle,
            detailsBlock: openMessageBlock
        ) {
            switch type {
            case let .text(message):
                TextMessageRow(message: message)
            case let .emoji(message):
                EmojiMessageRow(message: message)
            case let .service(message):
                ServiceMessageRow(message: message)
            case let .web(message):
                if let url = URL(string: message.text) {
                    WebView(content: .url(url))
                }
            case let .webContent(message):
                WebView(content: .html(message.text))
            case let .telegram(message):
                WebView(content: .telegram(message.link))
            }
        }
    }
}
