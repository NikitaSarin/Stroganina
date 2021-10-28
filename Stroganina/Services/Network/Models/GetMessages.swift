//
//  GetMessages.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 29.10.2021.
//

import Foundation

typealias ID = UInt

enum GetMessages {
    struct Input: Codable {
        let chatId: Chat.ID
        let limit: Int
        let lastMessageId: Message.ID?
        let reverse: Bool?
    }

    struct Output: Codable {
        struct Message: Codable {
            let user: UsersOutput.User
            let date: UInt
            let content: String
            let type: String
            let messageId: ID
            let chatId: Chat.ID
        }
        let messages: [Message]
    }

    struct UsersOutput: Codable {
        struct User: Codable {
            let name: String
            let userId: ID
            let isSelf: Bool
        }

        let users: [User]
    }
}

typealias GetMessagesRequest = Request<GetMessages.Input, GetMessages.Output>

extension Request {
    static var getMessages: GetMessagesRequest {
        GetMessagesRequest(method: "message/get_from_chat")
    }
}
