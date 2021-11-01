//
//  MessageRaw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

extension Raw {
    public struct Message: Codable {
        public let user: User
        public let date: UInt
        public let content: String
        public let messageId: ID
        public let chatId: ID
        @SafeCodable public var type: MessageType
    }
}
