//
//  ChatSetupView.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import SwiftUI

struct ChatSetupView: View {

    @ObservedObject var viewModel: ChatSetupViewModel

    var body: some View {
        VStack(spacing: 32) {
            if viewModel.users.count == 1 {
                Spacer()
                ActionButton("Create personal chat") {
                    viewModel.createPersonalButtonTapped()
                }
                HStack {
                    Spacer()
                    VStack {
                        Divider()
                    }
                    Text("or")
                        .font(.system(size: 14))
                        .lineLimit(8)
                        .foregroundColor(.tg_grey)
                    VStack {
                        Divider()
                    }
                    Spacer()
                }
            }
            Spacer()
            Text("Choose\nthe chat name")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            Spacer()
            TextField("Name", text: $viewModel.name)
                .multilineTextAlignment(.center)
                .frame(height: 60)
            ActionButton("Create") {
                viewModel.createButtonTapped()
            }
            Spacer()
        }
    }
}

struct ChatSetupView_Previews: PreviewProvider {

    struct Service: ChatSetupServiceProtocol {
        func createPersonalChat(with user: User, completion: @escaping (Result<Chat, Error>) -> Void) {
            completion(.success(.mock))
        }

        func createChat(
            with name: String,
            users: [User],
            completion: @escaping (Result<Chat, Error>) -> Void
        ) {
            completion(.success(.mock))
        }
    }

    static var previews: some View {
        NavigationView {
            ChatSetupView(
                viewModel: ChatSetupViewModel(
                    users: [.mock],
                    router: NewChatRouterMock(),
                    service: Service()
                )
            )
        }
    }
}
