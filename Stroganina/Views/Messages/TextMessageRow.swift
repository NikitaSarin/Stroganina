//
//  TextMessageRow.swift
//  Pentagram
//
//  Created by Сарин Никита Сергеевич on 21.03.2021.
//

import SwiftUI

extension Text {
    func bubble(isOutgoing: Bool) -> some View {
        font(.regular(size: 17))
        .foregroundColor(isOutgoing ? .tg_white : .sgn_primary)
        .lineLimit(nil)
    }
}

struct TextMessageRow: View {

    @ObservedObject var message: TextMessage

    private let isOutgoing: Bool

    init(
        message: TextMessage,
        isOutgoing: Bool? = nil
    ) {
        self.message = message
        self.isOutgoing = isOutgoing ?? message.isOutgoing
    }

    var body: some View {
        if #available(iOS 15, *) {
            Text({ () -> AttributedString in
                let text = try? AttributedString(
                    markdown: message.text,
                    options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .full)
                )
                return text ?? AttributedString(message.text)
            }()).bubble(isOutgoing: isOutgoing)
        } else {
            Text(message.text)
                .bubble(isOutgoing: isOutgoing)
        }
    }
}

struct TextMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextMessageRow(
                message: TextMessage(
                    base: .mock(.isOutgoing),
                    text: "Hello"
                )
            )
            TextMessageRow(
                message: TextMessage(
                    base: .mock(),
                    text: "Hello"
                )
            )
        }
    }
}
