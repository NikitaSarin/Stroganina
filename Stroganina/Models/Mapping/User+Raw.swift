//
//  User+Raw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import NetworkApi
import UIKit
import SwiftUI

extension User {
    init(_ raw: Raw.User) {
        self.id = raw.userId
        self.isSelf = raw.isSelf
        self.name = raw.name
        self.firstName = raw.firstName
        self.lastName = raw.lastName
        if let hex = raw.hex, let emoji = raw.emoji {
            self.picture = Picture(
                emoji: emoji,
                color: Color(UIColor(hex: hex))
            )
        }
    }
}
