//
//  User.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import UIKit

struct User: Identifiable {

    typealias ID = UInt

    let id: ID
    var name: String
    var isSelf: Bool
}

extension User {
    static let mock = User(id: 1, name: "Vova", isSelf: false)
}

extension User: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
