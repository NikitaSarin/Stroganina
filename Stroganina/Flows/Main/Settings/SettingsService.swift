//
//  SettingsService.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 02.11.2021.
//

protocol SettingsServiceProtocol {
    func logout()
}

final class SettingsService: SettingsServiceProtocol {

    private let store: Store

    init(store: Store) {
        self.store = store
    }

    func logout() {
        store.set(authorisationInfo: nil)
    }
}
