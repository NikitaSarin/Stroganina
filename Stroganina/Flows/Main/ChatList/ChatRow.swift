//
//  ChatRow.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 01.11.2021.
//

import SwiftUI

struct ChatRow: View {

    let chat: Chat

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(chat.title)
                .font(.medium(size: 17))
            if let message = chat.lastMessage {
                Text(message.type.description)
                    .font(.reqular(size: 14))
                    .foregroundColor(.tg_grey)
            }
            Divider()
        }
        .padding(4)
        .contentShape(Rectangle())
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chat: .mock)
    }
}
