//
//  ChatSetupViewModel.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import Combine
import Foundation

final class ChatSetupViewModel: ObservableObject {

    @Published var emptyNameCount: Int = 0
    @Published var name: String = ""

    let users: [User]

    private let service: ChatSetupServiceProtocol
    private let router: NewChatRouting

    init(
        users: [User],
        router: NewChatRouting,
        service: ChatSetupServiceProtocol
    ) {
        self.users = users
        self.router = router
        self.service = service
    }

    func createPersonalButtonTapped() {
        service.createPersonalChat(with: users[0]) { [weak self] result in
            switch result {
            case .success(let chat):
                self?.router.openChatScene(input: chat)
            case .failure:
                break
            }
        }
    }

    func createButtonTapped() {
        if name.isEmpty {
            emptyNameCount += 1
            return
        }
        service.createChat(with: name, users: users) { [weak self] result in
            switch result {
            case .success(let chat):
                self?.router.openChatScene(input: chat)
            case .failure:
                break
            }
        }
    }
}
