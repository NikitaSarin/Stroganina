//
//  UserSearchRow.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 03.11.2021.
//

import SwiftUI

struct UserRow: View {

    let user: User
    let showCheckbox: Bool
    @Binding var isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            ProfileView(user: user, size: .small)
            Text(user.name)
            Spacer()
            if showCheckbox {
                Image(systemName: isSelected
                      ? "checkmark.circle.fill"
                      : "circle")
                    .foregroundColor(.sgn_brand)
            }
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
                showCheckbox: true,
                isSelected: .constant(false)
            )
            UserRow(
                user: .mock,
                showCheckbox: true,
                isSelected: .constant(true)
            )
            UserRow(
                user: .mock,
                showCheckbox: false,
                isSelected: .constant(true)
            )
        }
    }
}
