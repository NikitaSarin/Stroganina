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
            self.content(for: type)
        }
    }
    
    func content(for type: MessageType) -> some View {
        Group {
            switch type {
            case let .text(message):
                TextMessageRow(message: message)
            case let .emoji(message):
                EmojiMessageRow(message: message)
            case let .service(message):
                ServiceMessageRow(message: message)
            }
        }
    }
}
