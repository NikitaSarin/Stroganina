//
//  UserSearchRow.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 03.11.2021.
//

import SwiftUI

struct UserRow: View {

    let user: User
    @Binding var isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isSelected
                  ? "checkmark.circle.fill"
                  : "circle")
                .foregroundColor(.sgn_brand)
            Text(user.name)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                isSelected.toggle()
            }
        }
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            UserRow(
                user: .mock,
                isSelected: .constant(false)
            )
            UserRow(
                user: .mock,
                isSelected: .constant(true)
            )
        }
    }
}
