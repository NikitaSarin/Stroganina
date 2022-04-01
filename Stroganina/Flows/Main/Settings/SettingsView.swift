//
//  SettingsView.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 01.11.2021.
//

import SwiftUI

struct SettingsView: View {

    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        VStack(spacing: 20) {
            if let user = viewModel.user {
                SettingsHeader(user: user)
            }
            Spacer()
            Section {
                Spacer()
                Text("Log out")
                    .foregroundColor(.red)
                    .font(.regular(size: 18))
                    .frame(height: 30)
                Spacer()
            }
            .padding(.bottom, 12)
            .onTapGesture {
                viewModel.logoutTapped()
            }
        }
        .padding(16)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .clipped()
        .padding(.top, safeAreaInsets.top)
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            viewModel.start()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {

    struct Service: SettingsServiceProtocol {
        func logout() {}

        func fetchSelf(completion: @escaping (Result<User, Error>) -> Void) {
            completion(.success(.mock))
        }
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
