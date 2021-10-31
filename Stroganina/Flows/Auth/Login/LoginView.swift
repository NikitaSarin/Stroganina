//
//  LoginView.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import SwiftUI

struct LoginView: View {

    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("Login")
                .font(.title)
                .bold()
            Spacer()
            TextField("Username", text: $viewModel.username)
                .multilineTextAlignment(.center)
                .frame(height: 60)
            SecureField("Password", text: $viewModel.password)
                .multilineTextAlignment(.center)
                .frame(height: 60)
            ActionButton("Login") {
                viewModel.loginButtonTapped()
            }
            Spacer()
        }
    }
}

struct LoginView_Previews: PreviewProvider {

    struct Service: LoginServiceProtocol {
        func login(with username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
            completion(.success(()))
        }
    }

    static var previews: some View {
        LoginView(
            viewModel: LoginViewModel(
                router: AuthRouterMock(),
                service: Service()
            )
        )
    }
}
