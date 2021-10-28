//
//  ChatHeader.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import SwiftUI

struct ChatHeader: View {

    @ObservedObject var chat: Chat

    var body: some View {
        VStack {
            Spacer(minLength: 0)
            Text(chat.title)
                .font(.title2)
                .bold()
            Spacer(minLength: 0)
            Color.secondary
                .frame(height: 1)
                .opacity(0.2)
        }
        .frame(width: .infinity, height: 60)
    }
}

struct ChatHeader_Previews: PreviewProvider {
    static var previews: some View {
        ChatHeader(chat: .mock)
    }
}
