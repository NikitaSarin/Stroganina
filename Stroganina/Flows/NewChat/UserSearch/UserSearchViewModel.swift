//
//  UserSearchViewModel.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import Combine
import Foundation
import SwiftUI

protocol UserSearchOutputHandler {
    func process(output: [User])
}

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

    let multipleUsers: Bool
    private let handler: UserSearchOutputHandler
    private let service: UserSearchServiceProtocol

    init(
        multipleUsers: Bool,
        handler: UserSearchOutputHandler,
        service: UserSearchServiceProtocol
    ) {
        self.multipleUsers = multipleUsers
        self.handler = handler
        self.service = service
    }

    func set(user: User, selected: Bool) {
        if selected {
            multipleUsers
            ? selectedUsers.append(user)
            : handler.process(output: users)
        } else {
            selectedUsers.removeAll(where: { $0 == user })
        }
    }

    func nextButtonTapped() {
        handler.process(output: users)
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
