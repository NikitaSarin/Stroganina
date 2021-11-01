//
//  User+Raw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import NetworkApi

extension User {
    init(_ raw: Raw.User) {
        self.name = raw.name
        self.id = raw.userId
        self.isSelf = raw.isSelf
    }
}
