//
//  EmojiMessageRow.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 26.05.2021.
//

import SwiftUI

struct EmojiMessageRow: View {

    let message: TextMessage

    var body: some View {
        Text(message.text)
            .font(.system(size: 60))
            .frame(width: 80, height: 80)
    }
}

struct EmojiMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMessageRow(message: TextMessage(base: .mock(), text: "🥳"))
    }
}
