//
//  User+Raw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import Foundation

extension User {
    init(_ raw: UserRaw) {
        self.name = raw.name
        self.id = raw.userId
        self.isSelf = raw.isSelf
    }
}
