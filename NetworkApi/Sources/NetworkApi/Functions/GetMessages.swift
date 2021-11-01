//
//  GetMessages.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 29.10.2021.
//

public struct GetMessages {
    let chatId: ID
    let limit: Int
    let lastMessageId: ID?
    let reverse: Bool?

    public init(chatId: ID, limit: Int, lastMessageId: ID?, reverse: Bool?) {
        self.chatId = chatId
        self.limit = limit
        self.lastMessageId = lastMessageId
        self.reverse = reverse
    }
}

extension GetMessages: ApiFunction {

    public static var method = "message/get_from_chat"

    public struct Response: Codable {
        public let messages: [Raw.Message]
    }

}
