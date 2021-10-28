//
//  DocumentMessageRow.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 27.05.2021.
//

import SwiftUI

struct DocumentMessageRow: View {

    @ObservedObject var message: DocumentMessage
    private let isOutgoing: Bool

    init(
        message: DocumentMessage,
        isOutgoing: Bool? = nil
    ) {
        self.message = message
        self.isOutgoing = isOutgoing ?? message.isOutgoing
    }

    var body: some View {
        HStack(spacing: 8) {
            Image("document")
                .resizable()
                .frame(width: 42, height: 42)
                .foregroundColor(color(contrast: !isOutgoing))
                .background(color(contrast: isOutgoing))
                .cornerRadius(21)
            VStack(alignment: .leading, spacing: 2) {
                Text(message.name)
                    .font(.reqular(size: 17))
                Text(message.size)
                    .font(.reqular(size: 14))
            }
            .foregroundColor(isOutgoing ? .tg_white : .tg_black)
            .lineLimit(1)
            Spacer(minLength: 0)
        }
    }

    private func color(contrast: Bool) -> Color {
        contrast ? .tg_blue : .tg_white
    }
}

struct DocumentMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DocumentMessageRow(
                message: DocumentMessage(
                    base: .mock(.isOutgoing),
                    name: "chicha.mp3",
                    size: "100 GB"
                )
            )
            DocumentMessageRow(
                message: DocumentMessage(
                    base: .mock(),
                    name: "IMG_1234.JPG",
                    size: "100 GB"
                )
            )
        }
        .background(Color.gray)
    }
}
