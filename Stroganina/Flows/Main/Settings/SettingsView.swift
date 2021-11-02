//
//  SettingsView.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 01.11.2021.
//

import SwiftUI

struct SettingsView: View {

    let viewModel: SettingsViewModel

    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                header
                Spacer()
            }
            Section {
                Spacer()
                Text("Logout")
                    .foregroundColor(.red)
                    .font(.reqular(size: 18))
                    .frame(height: 30)
                Spacer()
            }
            .onTapGesture {
                viewModel.logoutTapped()
            }
        }
        .padding(16)
    }

    private var header: some View {
        Section {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("🐲")
                        .font(.reqular(size: 38))
                    Spacer()
                }
                Spacer()
            }
            .background(Color.yellow)
            .frame(edge: 80)
            .cornerRadius(50)
            VStack(alignment: .leading, spacing: 6) {
                Text("Mr. Smaug")
                    .font(.medium(size: 20))
                Text("@dragonborn")
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

struct SettingsView_Previews: PreviewProvider {

    struct Service: SettingsServiceProtocol {
        func logout() {}
    }

    struct Router: SettingsRouting {
        func openStartScene(animated: Bool) {}
    }

    static var previews: some View {
        SettingsView(
            viewModel: SettingsViewModel(
                router: Router(),
                service: Service()
            )
        )
    }
}
