//
//  ChatRaw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

extension Raw {
    public struct Chat: Codable {

        public enum ChatType: String, Codable, UnknownSafable {
            case group
            case personal
            case unknown
        }

        public let name: String
        public let chatId: ID
        public let message: Message?
        public let lastMessageId: ID?
        public let notReadCount: Int?
        @SafeCodable public var type: ChatType
    }
}
