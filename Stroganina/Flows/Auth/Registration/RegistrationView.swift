//
//  RegistrationView.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import SwiftUI

struct RegistrationView: View {

    @ObservedObject var viewModel: RegistrationViewModel

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("Registration")
                .font(.title)
                .bold()
            Spacer()
            TextField("Username", text: $viewModel.username)
                .multilineTextAlignment(.center)
                .frame(height: 60)
            SecureField("Password", text: $viewModel.password)
                .multilineTextAlignment(.center)
                .frame(height: 60)
            ActionButton("Register") {
                viewModel.registerButtonTapped()
            }
            Spacer()
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {

    struct Service: RegistrationServiceProtocol {
        func register(
            with username: String,
            password: String,
            completion: @escaping (Result<Void, Error>) -> Void
        ) {
            completion(.success(()))
        }
    }

    static var previews: some View {
        RegistrationView(
            viewModel: .init(
                router: AuthRouterMock(),
                service: Service()
            )
        )
    }
}
