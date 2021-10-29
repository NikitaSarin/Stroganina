//
//  LoginService.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation

final class LoginService: LoginServiceProtocol {

    private let api: Networking
    private let store: Store

    init(
        api: Networking,
        store: Store
    ) {
        self.api = api
        self.store = store
    }

    func login(
        with username: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let function = UserLogin(name: username)
        api.perform(function) { [weak self] result in
            switch result {
            case let .success(output):
                self?.store.set(token: output.token)
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
