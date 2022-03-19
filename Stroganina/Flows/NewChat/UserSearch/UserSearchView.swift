//
//  UserSearchView.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import SwiftUI

struct UserSearchView: View {

    @ObservedObject var viewModel: UserSearchViewModel

    var body: some View {
        VStack(spacing: 10) {
            searchBar
            selectedUsers
            if viewModel.searchEnabled {
                searchResults
            } else {
                Spacer()
                Text("Type 3 or more characters\nto search for users to add them\nto a new chat")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.tg_grey)
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .transition(.opacity)
        .animation(.spring())
        .navigationBarTitle("Users")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Next") {
                    viewModel.nextButtonTapped()
                }
                .disabled(!viewModel.nextStepEnabled)
            }
        }
    }

    private var searchBar: some View {
        TextField("Username", text: $viewModel.searchText)
            .multilineTextAlignment(.center)
            .frame(height: 40)
            .background(Color.sgn_surface)
            .cornerRadius(8)
            .padding(.top, 8)
            .padding(.horizontal, 20)
    }

    private var selectedUsers: some View {
        FlowLayout(
            mode: .static,
            items: viewModel.selectedUsers
        ) { user in
            UserTag(user: user) {
                viewModel.set(user: user, selected: false)
            }
            .transition(.scale)
        }
        .padding(.top, 10)
    }

    private var searchResults: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.users) { user in
                    UserRow(
                        user: user,
                        isSelected: .init(
                            get: {
                                viewModel.selectedUsers.contains(user)
                            }, set: {
                                viewModel.set(user: user, selected: $0)
                            }
                        )
                    )
                    Divider()
                }
            }
        }
    }
}

struct UserSearchView_Previews: PreviewProvider {
    static var viewModel: UserSearchViewModel {
        let viewModel = UserSearchViewModel(
            service: Service(),
            selectedUsersHandler: { _ in }
        )
        viewModel.searchText = "kek"
        viewModel.selectedUsers = [.mock]
        viewModel.users = [.mock, .mock]
        return viewModel
    }

    static var previews: some View {
        NavigationView {
            UserSearchView(
                viewModel: viewModel
            )
        }
    }

    struct Service: UserSearchServiceProtocol {
        func searchUsers(
            with name: String,
            completion: @escaping (Result<[User], Error>) -> Void
        ) {
            completion(.success([.mock, .mock, .mock]))
        }
    }
}
