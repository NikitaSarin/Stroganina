//
//  TitledImageRow.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 02.06.2021.
//

import SwiftUI

struct TitledImageRow: View {

    let imageName: String
    let title: String
    let tap: VoidClosure?

    var body: some View {
        Button(action: {
                tap?()
        }, label: {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(edge: 24)
                .cornerRadius(12)
            Text(title)
                .font(.regular(size: 17))
            .lineLimit(1)
            Spacer(minLength: 0)
        })
    }
}

struct TitledImageRow_Previews: PreviewProvider {
    static var previews: some View {
        TitledImageRow(imageName: "mops", title: "Title", tap: nil)
    }
}
