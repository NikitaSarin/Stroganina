//
//  User.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import UIKit

struct User: Hashable {

    typealias ID = UInt

    let id: ID
    var name: String?
}

extension User {
    static let mock = User(id: 1, name: "Vova")
}
