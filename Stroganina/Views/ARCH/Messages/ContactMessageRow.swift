//
//  ContactMessageRow.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 27.05.2021.
//

import SwiftUI

struct ContactMessageRow: View {

    @ObservedObject var message: ContactMessage
    private let isOutgoing: Bool

    init(
        message: ContactMessage,
        isOutgoing: Bool? = nil
    ) {
        self.message = message
        self.isOutgoing = isOutgoing ?? message.isOutgoing
    }

    var body: some View {
        HStack(spacing: 8) {
            ProfileView(image: message.image, text: message.name)
            VStack(alignment: .leading, spacing: 2) {
                Text(message.name)
                    .font(.reqular(size: 17))
                Text(message.phone)
                    .font(.reqular(size: 14))
            }
            .foregroundColor(isOutgoing ? .tg_white : .tg_black)
            .lineLimit(1)
            Spacer(minLength: 0)
        }
    }
}

struct ContactMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        ContactMessageRow(
            message: ContactMessage(
                base: .mock(), name: "Ivan Ivanov",
                phone: "88005553535",
                image: .mops
            )
        )
        .background(Color.white)
    }
}
