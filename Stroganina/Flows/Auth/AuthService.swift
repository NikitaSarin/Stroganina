//
//  AuthService.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation

final class AuthService {

    var isAuthorized: Bool {
        !(store.token ?? "").isEmpty
    }

    private let store: Store

    init(store: Store) {
        self.store = store
    }
}
