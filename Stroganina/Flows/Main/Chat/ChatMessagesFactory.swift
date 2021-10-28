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
            }
        }
    }
}
