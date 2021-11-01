//
//  UserRaw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

extension Raw {
    public struct User: Codable {
        public let name: String
        public let userId: ID
        public let isSelf: Bool
    }
}
