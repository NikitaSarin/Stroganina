//
//  LoginService.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation

final class LoginService: LoginServiceProtocol {

    private let store: Store

    init(store: Store) {
        self.store = store
    }

    func login(
        with username: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        completion(.success(()))
    }
}
