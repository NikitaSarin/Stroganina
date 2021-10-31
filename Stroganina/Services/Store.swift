//
//  Store.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation

final class Store {

    private enum Key: String {
        case token
        case secretKey
    }

    private(set) var authorisationInfo: AuthorisationInfo?

    private let defaults = UserDefaults.standard

    func set(authorisationInfo: AuthorisationInfo?) {
        self.authorisationInfo = authorisationInfo
        save()
    }

    func load() {
        guard
            let token = defaults.string(forKey: Key.token.rawValue),
            let secretKey = defaults.string(forKey: Key.secretKey.rawValue)
        else {
            return
        }
        self.authorisationInfo = AuthorisationInfo(token: token, secretKey: secretKey)
    }

    func save() {
        defaults.set(authorisationInfo?.token, forKey: Key.token.rawValue)
        defaults.set(authorisationInfo?.secretKey, forKey: Key.secretKey.rawValue)
    }

}
