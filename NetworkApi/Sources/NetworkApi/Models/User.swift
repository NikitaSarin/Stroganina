//
//  UserRaw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

extension Raw {
    public struct User: Codable {
        public let userId: ID
        public let isSelf: Bool
        public let name: String
        public let firstName: String?
        public let lastName: String?
        public let hex: String?
        public let emoji: String?
    }
}
