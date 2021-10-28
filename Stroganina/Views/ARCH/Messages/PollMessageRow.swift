//
//  PollMessageRow.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 30.05.2021.
//

import SwiftUI

struct PollMessageRow: View {

    let message: PollMessage

    private var poolType: String {
        switch message.mode {
        case .regular:
            return "Poll"
        case .quiz:
            return "Quiz"
        }
    }

    private var privacy: String {
        message.isAnonymous ? "Anonymous" : "Public"
    }

    private let isOutgoing: Bool

    init(
        message: PollMessage,
        isOutgoing: Bool? = nil
    ) {
        self.message = message
        self.isOutgoing = isOutgoing ?? message.isOutgoing
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(message.question)
                .bubble(isOutgoing: isOutgoing)
            Text(privacy + " " + poolType)
                .font(.reqular(size: 14))
                .foregroundColor(isOutgoing ? .tg_white70 : .tg_grey)
        }
    }
}

struct PollMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        PollMessageRow(
            message: PollMessage(
                base: .mock(.isOutgoing),
                isAnonymous: true,
                isClosed: true, question: "Who?",
                options: [],
                mode: .regular(allowMultipleAnwsers: true
                )
            )
        )
    }
}
