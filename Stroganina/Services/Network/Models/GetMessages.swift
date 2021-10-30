//
//  GetMessages.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 29.10.2021.
//

import Foundation

typealias ID = UInt

struct GetMessages {
    let chatId: Chat.ID
    let limit: Int
    let lastMessageId: Message.ID?
    let reverse: Bool?
}

extension GetMessages: ApiFunction {

    static var method = "message/get_from_chat"

    struct Response: Codable {
        
        struct User: Codable {
            let name: String
            let userId: ID
            let isSelf: Bool
        }

        struct Message: Codable {
            let user: User
            let date: UInt
            let content: String
            let type: String
            let messageId: ID
            let chatId: Chat.ID
        }

        let messages: [Message]
    }

}
