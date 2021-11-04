//
//  SettingsService.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 02.11.2021.
//

import NetworkApi

protocol SettingsServiceProtocol {
    func logout()

    func fetchSelf(completion: @escaping (Result<User, Error>) -> Void)
}

final class SettingsService: SettingsServiceProtocol {

    private let api: Networking
    private let store: Store

    init(
        api: Networking,
        store: Store
    ) {
        self.api = api
        self.store = store
    }

    func logout() {
        store.set(authorisationInfo: nil)
    }

    func fetchSelf(completion: @escaping (Result<User, Error>) -> Void) {
        api.perform(GetSelf()) { result in
            switch result {
            case let .success(response):
                let user = User(response)
                completion(.success(user))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
