//
//  Section.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 30.05.2021.
//

import SwiftUI

struct Section<Content: View>: View {
    let title: String
    let content: Content

    init(
        _ title: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 0) {
                Text(title.uppercased())
                    .font(.reqular(size: 14))
                    .foregroundColor(.tg_grey)
                    .padding(.horizontal, 9)
                Spacer(minLength: 0)
            }
            content
        }
    }
}

struct Section_Previews: PreviewProvider {
    static var previews: some View {
        Section("Title") {
            Text("Hehe")
        }
    }
}
