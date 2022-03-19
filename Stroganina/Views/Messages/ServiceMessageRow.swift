//
//  ServiceMessageRow.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 27.05.2021.
//

import SwiftUI

struct ServiceMessageRow: View {
    let message: TextMessage
    var body: some View {
        Text(message.text)
            .font(.system(size: 14))
            .lineLimit(8)
            .foregroundColor(.tg_grey)
    }
}

struct ServiceMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        ServiceMessageRow(message: TextMessage(base: .mock(), text: "hello hello ekrjvjkbjkvb"))
    }
}
