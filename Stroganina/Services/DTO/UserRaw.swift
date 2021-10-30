//
//  UserRaw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import Foundation

struct UserRaw: Codable {
    let name: String
    let userId: ID
    let isSelf: Bool
}
