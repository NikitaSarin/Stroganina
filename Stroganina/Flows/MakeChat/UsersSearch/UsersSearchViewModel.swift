//
//  UsersSearchViewModel.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import Combine
import Foundation
import SwiftUI

final class UsersSearchViewModel: ObservableObject {
    @Published var searchText: String = "" {
        didSet {
            if oldValue != searchText && searchText.count > 2 {
                update()
            }
        }
    }
    @Published var users = [User]()
    @Published var selectUsers = [User]()
    
    private let service: UsersSearchServiceProtocol
    private let router: MakeChatRouting
    
    private let searchUpdateScheduler = Scheduler(defaultDelay: 0.5)
    
    init(
        service: UsersSearchServiceProtocol,
        router: MakeChatRouting
    ) {
        self.service = service
        self.router = router
    }
    
    func endSelect() {
        router.openMakeChatScreen(with: selectUsers)
    }

    func tapInUser(_ user: User) {
        if isSelectedUser(user) {
            selectUsers.removeAll(where: { $0 == user })
        } else {
            selectUsers.append(user)
        }
    }
    
    func isSelectedUser(_ user: User) -> Bool {
        selectUsers.contains(user)
    }
    
    private func update() {
        searchUpdateScheduler.schedule { [weak self, searchText] in
            DispatchQueue.main.async {
                self?.service.fetch(with: searchText, completion: { result in
                    self?.didLoad(result)
                })
            }
        }
    }
    
    private func didLoad(_ result: Result<[User], Error>) {
        switch result {
        case .success(let users):
            self.users = users.filter { $0.isSelf == false }
        case .failure:
            break
        }
    }
}
