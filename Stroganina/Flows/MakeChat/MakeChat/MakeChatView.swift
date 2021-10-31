//
//  MakeChatView.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import SwiftUI

struct MakeChatView: View {

    @ObservedObject var viewModel: MakeChatViewModel

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("Create chat")
                .font(.title)
                .bold()
            Spacer()
            TextField("Name", text: $viewModel.name)
                .multilineTextAlignment(.center)
                .frame(height: 60)
            ActionButton("Create") {
                viewModel.makeChatButtonTapped()
            }
            Spacer()
        }
    }
}

struct MakeChatView_Previews: PreviewProvider {

    struct Service: MakeChatServiceProtocol {
        func makeChat(with name: String, users: [User], completion: @escaping (Result<Chat, Error>) -> Void) {
            completion(.success(.mock))
        }
    }

    static var previews: some View {
        NavigationView {
            MakeChatView(
                viewModel: MakeChatViewModel(
                    users: [],
                    router: MakeChatRoutingMock(),
                    service: Service()
                )
            )
        }
    }
}
