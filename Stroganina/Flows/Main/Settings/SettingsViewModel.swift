//
//  SettingsViewModel.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 02.11.2021.
//

import Combine

protocol SettingsRouting {
    func openStartScene(animated: Bool)
}

final class SettingsViewModel: ObservableObject {

    @Published var user: User?

    private let router: SettingsRouting
    private let service: SettingsServiceProtocol

    init(
        router: SettingsRouting,
        service: SettingsServiceProtocol
    ) {
        self.router = router
        self.service = service
    }

    func start() {
        service.fetchSelf { [weak self] result in
            switch result {
            case let .success(user):
                self?.user = user
            case .failure:
                break
            }
        }
    }

    func logoutTapped() {
        service.logout()
        router.openStartScene(animated: true)
    }
}
