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
    }

    private(set) var token: String?

    private let defaults = UserDefaults.standard

    func set(token: String) {
        self.token = token
        save()
    }

    func load() {
        token = defaults.string(forKey: Key.token.rawValue)
    }

    func save() {
        defaults.set(token, forKey: Key.token.rawValue)
    }

}
