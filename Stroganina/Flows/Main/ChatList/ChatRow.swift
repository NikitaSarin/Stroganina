//
//  ChatRow.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 01.11.2021.
//

import SwiftUI

struct ChatRow: View {
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM"
        return formatter
    }()

    @ObservedObject var chat: Chat

    private var date: String {
        guard let date = chat.lastMessage?.base.date else {
            return ""
        }
        return Self.formatter.string(from: date)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ProfileView(mode: .text(chat.title), size: .medium)
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(chat.title)
                        .font(.medium(size: 15))
                    Spacer()
                    Text(date)
                        .font(.regular(size: 12))
                        .foregroundColor(.tg_grey)
                        .padding(.trailing, 2)
                }
                if let message = chat.lastMessage {
                    if #available(iOS 15, *) {
                        Text({ () -> AttributedString in
                            let text = try? NSAttributedString(
                                markdown: message.type.description,
                                options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .full)
                            ).string
                            return AttributedString(text ?? message.type.description)
                        }())
                            .font(.regular(size: 12))
                            .lineLimit(2)
                            .foregroundColor(.tg_grey)
                    } else {
                        Text(message.type.description)
                            .font(.regular(size: 12))
                            .lineLimit(2)
                            .foregroundColor(.tg_grey)
                    }
                }
            }
            .padding(.vertical, 2)
        }
        .contentShape(Rectangle())
        .padding(.vertical, 4)
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chat: .mock)
    }
}
