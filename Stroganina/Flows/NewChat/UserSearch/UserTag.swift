//
//  UserTagView.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 02.11.2021.
//

import SwiftUI

struct UserTag: View {

    let user: User
    let deleteAction: VoidClosure?

    var body: some View {
        HStack(spacing: 6) {
            Text(user.name)
            Image(systemName: "xmark")
                .resizable()
                .padding(4)
                .foregroundColor(.tg_grey)
                .frame(edge: 20)
                .onTapGesture {
                    deleteAction?()
                }
        }
        .padding(.leading, 12)
        .padding(.trailing, 6)
        .padding(.vertical, 4)
        .background(Color.sgn_surface)
        .cornerRadius(12)
    }
}

struct UserTag_Previews: PreviewProvider {
    static var previews: some View {
        UserTag(user: .mock, deleteAction: nil)
    }
}
