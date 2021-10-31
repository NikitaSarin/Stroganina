//
//  UsersSearchView.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import SwiftUI

struct UsersSearchView: View {
    @ObservedObject var viewModel: UsersSearchViewModel

    var body: some View {
        VStack {
            content()
        }
        .searchable(text:  $viewModel.searchText)
        .navigationTitle("Users")
    }
    
    private func content() -> some View {
        ScrollView {
            VStack {
                if viewModel.selectUsers.count != 0 {
                    LazyVStack {
                        titleView("Selected users:")
                        ForEach(viewModel.selectUsers) { user in
                            userView(user: user)
                        }
                    }
                    ActionButton("Selected") {
                        viewModel.endSelect()
                    }
                    Divider()
                }
                if viewModel.users.count != 0 {
                    titleView("Users:")
                    LazyVStack {
                        ForEach(viewModel.users) { user in
                            userView(user: user)
                        }
                    }
                }
                else if viewModel.searchText.count < 3 {
                    messageView(text: "Enter at least\nthree characters")
                } else {
                    messageView(text: "Users not found")
                }
            }
        }
    }
    
    private func titleView(_ title: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.tg_grey)
                .font(.reqular(size: 11))
            Spacer()
        }
        .padding(.horizontal, 25)
    }
    
    private func messageView(text: String) -> some View {
        VStack {
            Spacer()
            Text(text)
                .foregroundColor(.tg_grey)
                .font(.reqular(size: 17))
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
    
    private func userView(user: User) -> some View {
        HStack {
            Text(user.name)
                .frame(height: 40)
                .multilineTextAlignment(.leading)
                .onTapGesture {
                    viewModel.tapInUser(user)
                }
            Spacer()
            if viewModel.isSelectedUser(user) {
                Image(systemName: "checkmark")
            }
        }
        .padding(.horizontal, 25)
    }
}

struct UsersSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UsersSearchView(
                viewModel: UsersSearchViewModel(
                    service: Service(),
                    router: MakeChatRoutingMock()
                )
            )
        }
    }

    struct Service: UsersSearchServiceProtocol {
        func fetch(with name: String, completion: @escaping (Result<[User], Error>) -> Void) {
            completion(.success([.mock, .mock, .mock]))
        }
    }
}
