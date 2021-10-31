//
//  MakeChatViewModel.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import Combine
import Foundation

final class MakeChatViewModel: ObservableObject {

    @Published var name: String = ""

    private let service: MakeChatServiceProtocol
    private let router: MakeChatRouting
    private let users: [User]

    init(
        users: [User],
        router: MakeChatRouting,
        service: MakeChatServiceProtocol
    ) {
        self.users = users
        self.router = router
        self.service = service
    }

    func makeChatButtonTapped() {
        service.makeChat(with: name, users: users) { [weak self] result in
            switch result {
            case .success(let chat):
                self?.router.openMakeChat(chat)
            case .failure:
                break
            }
        }
    }
}
