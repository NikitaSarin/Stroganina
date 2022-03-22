//
//  MessageType+TextSkeleton.swift
//  Stroganina
//
//  Created by Alex Shipin on 22.03.2022.
//

import Foundation

extension MessageType {
    static func makeTextSkeletonType(
        content: String,
        chatId: Chat.ID
    ) -> Self {
        let identifier = MessageIdentifier.make(with: nil)
        let base = Message(
            id: identifier,
            date: Date(),
            chatId: chatId,
            remoteId: nil,
            state: .awaiting
        )
        if content.isSingleEmoji {
            return .emoji(TextMessage(base: base, text: content))
        } else {
            return .text(TextMessage(base: base, text: content))
        }
    }
}
