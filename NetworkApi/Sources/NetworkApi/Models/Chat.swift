//
//  ChatRaw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

extension Raw {
    public struct Chat: Codable {
        public let name: String
        public let chatId: ID
        public let isPersonal: Bool
        public let message: Message?
        public let lastMessageId: ID?
        public let notReadCount: Int?
    }
}
