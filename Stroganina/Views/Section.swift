//
//  Section.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 30.05.2021.
//

import SwiftUI

struct Section<Content: View>: View {
    let content: Content

    init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 14) {
            content
        }
        .padding(12)
        .background(Color.sgn_surface)
        .cornerRadius(14)
    }
}

struct Section_Previews: PreviewProvider {
    static var previews: some View {
        Section {
            Text("Hehe")
        }
    }
}
