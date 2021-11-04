//
//  SettingsHeader.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 04.11.2021.
//

import SwiftUI

struct SettingsHeader: View {

    let user: User

    var body: some View {
        Section {
            ProfileView(user: user)
            VStack(alignment: .leading, spacing: 6) {
                Text(user.fullName)
                    .font(.medium(size: 20))
                Text("@\(user.name.lowercased())")
                    .foregroundColor(.tg_grey)
                    .font(.reqular(size: 16))
            }
            Spacer()
            Image(systemName: "chevron.forward")
                .frame(edge: 24)
                .foregroundColor(.tg_grey)
        }
    }
}

struct SettingsHeader_Previews: PreviewProvider {
    static var previews: some View {
        SettingsHeader(user: .mock)
    }
}
