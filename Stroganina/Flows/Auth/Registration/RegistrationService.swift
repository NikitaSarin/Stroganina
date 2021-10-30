//
//  RegistrationService.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation

protocol RegistrationServiceProtocol {
    func register(
        with username: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class RegistrationService: RegistrationServiceProtocol {

    private let api: Networking
    private let store: Store

    init(api: Networking, store: Store) {
        self.api = api
        self.store = store
    }

    func register(
        with username: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let context = AuthorisationContext(store: store, username: username, password: password)
        let function = UserRegistration(
            name: username,
            securityHash: context.securityHash,
            userPublicKey: context.publicUserKey
        )

        api.perform(function) { result in
            switch result {
            case let .success(output):
                context.success(
                    serverPublicKey: output.serverPublicKey,
                    token: output.token,
                    completion: completion
                )
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
