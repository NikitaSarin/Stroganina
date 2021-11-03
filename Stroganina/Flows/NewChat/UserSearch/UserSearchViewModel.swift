//
//  UserSearchViewModel.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import Combine
import Foundation
import SwiftUI

final class UserSearchViewModel: ObservableObject {

    @Published var users = [User]()
    @Published var selectedUsers = [User]()
    @Published var searchText = "" {
        didSet {
            if searchEnabled {
                if oldValue != searchText {
                    update()
                }
            } else {
                users = []
            }
        }
    }
    var nextStepEnabled: Bool {
        !selectedUsers.isEmpty
    }
    var searchEnabled: Bool {
        searchText.count > 2
    }

    private let service: UserSearchServiceProtocol
    private let router: NewChatRouting

    init(
        service: UserSearchServiceProtocol,
        router: NewChatRouting
    ) {
        self.service = service
        self.router = router
    }

    func set(user: User, selected: Bool) {
        if selected {
            selectedUsers.append(user)
        } else {
            selectedUsers.removeAll(where: { $0 == user })
        }
    }

    func nextButtonTapped() {
        router.openChatSetupScene(input: selectedUsers)
    }

    private func update() {
        service.searchUsers(with: searchText) { [weak self] result in
            switch result {
            case .success(let users):
                guard self?.searchEnabled == true else { return }
                self?.users = users.filter { $0.isSelf == false }
            case .failure:
                break
            }
        }
    }
}