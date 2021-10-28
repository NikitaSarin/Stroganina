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
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class RegistrationService: RegistrationServiceProtocol {

    private let store: Store

    init(store: Store) {
        self.store = store
    }

    func register(
        with username: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        completion(.success(()))
    }
}
