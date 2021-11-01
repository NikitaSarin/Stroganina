//
//  SettingsViewModel.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 02.11.2021.
//

protocol SettingsRouting {
    func openStartScene(animated: Bool)
}

final class SettingsViewModel {

    private let router: SettingsRouting
    private let service: SettingsServiceProtocol

    init(
        router: SettingsRouting,
        service: SettingsServiceProtocol
    ) {
        self.router = router
        self.service = service
    }

    func logoutTapped() {
        service.logout()
        router.openStartScene(animated: true)
    }
}
