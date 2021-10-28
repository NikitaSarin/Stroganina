//
//  ReplyView.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 05.06.2021.
//

import SwiftUI

struct ReplyView: View {

    let isOutgoing: Bool
    let reply: BaseMessage.Reply
    
    var body: some View {
        HStack(spacing: 6) {
            Rectangle()
                .fill(isOutgoing ? Color.tg_white : Color.tg_blue)
                .frame(width: 2, height: 30)
                .cornerRadius(3)
            VStack(alignment: .leading, spacing: 0) {
                Text(reply.sender ?? "")
                    .font(.medium(size: 14))
                    .foregroundColor(isOutgoing ? Color.tg_white : Color.tg_blue)
                Text(reply.text ?? "")
                    .font(.reqular(size: 17))
                    .foregroundColor(isOutgoing ? .tg_white : .tg_black)
            }
            .lineLimit(1)
        }
    }
}

struct ReplyView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ReplyView(
                isOutgoing: true,
                reply: .init(messageId: 1, text: "Hello", sender: "Ivan")
            )
            ReplyView(
                isOutgoing: false,
                reply: .init(messageId: 1, text: "Hello", sender: "Ivan")
            )
        }

    }
}
