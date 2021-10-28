//
//  LoginService.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation

final class LoginService: LoginServiceProtocol {

    private let network: Networking
    private let store: Store

    init(
        network: Networking,
        store: Store
    ) {
        self.network = network
        self.store = store
    }

    func login(
        with username: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        network.send(
            UserLoginRequest.userLogin,
            parameters: UserLogin.Input(name: username)
        ) { [weak self] result in
            switch result {
            case let .success(output):
                self?.store.token = output.token
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
