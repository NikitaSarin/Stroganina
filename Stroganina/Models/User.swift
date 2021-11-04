//
//  User.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import UIKit
import SwiftUI

struct User: Identifiable {

    struct Picture {
        let emoji: String
        let color: Color
    }

    typealias ID = UInt

    let id: ID
    let isSelf: Bool
    let name: String
    let firstName: String?
    let lastName: String?
    var picture: Picture?

    var fullName: String {
        if let first = firstName, !first.isEmpty {
            return first + " " + (lastName ?? "")
        }
        if let last = lastName, !last.isEmpty {
            return (firstName ?? "") + " " + last
        }
        return name
    }
}

extension User {
    static let mock = User(
        id: 1,
        isSelf: true,
        name: "mr_boxmastaer",
        firstName: "Oleg",
        lastName: "Dudkin",
        picture: .init(emoji: "🐲", color: .yellow)
    )
}

extension User: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
