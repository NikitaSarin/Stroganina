//
//  ChatService.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation

final class ChatService: ChatServiceProtocol {

    var allMessagesFetched: Bool = true

    weak var delegate: ChatServiceDelegate?

    func fetch(from messageId: Message.ID?) {
        let messages: [MessageWrapper] = (0...30).map { index in
            MessageWrapper(
                type: .text(
                    .init(
                        base: .mock(
                            index % 2 == 0 ? .isOutgoing : .default,
                            id: index
                        ),
                        text: "Hello \(index)"
                    )
                )
            )
        }
        delegate?.didChange(messages: messages)
    }
}
