//
//  ActionButton.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import SwiftUI

struct ActionButton: View {

    private let title: String
    private let action: VoidClosure

    init(
        _ title: String,
        action: @escaping VoidClosure
    ) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(title)
                .foregroundColor(.tg_white)
                .bold()
                .padding()
                .frame(minWidth: 180)
                .background(Color.sgn_brand)
                .cornerRadius(14)
        })
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton("Hello", action: {})
    }
}
