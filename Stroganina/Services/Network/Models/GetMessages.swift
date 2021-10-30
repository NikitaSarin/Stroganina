//
//  GetMessages.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 29.10.2021.
//

import Foundation

struct GetMessages {
    let chatId: Chat.ID
    let limit: Int
    let lastMessageId: Message.ID?
    let reverse: Bool?
}

extension GetMessages: ApiFunction {

    static var method = "message/get_from_chat"

    struct Response: Codable {
        let messages: [MessageRaw]
    }

}
