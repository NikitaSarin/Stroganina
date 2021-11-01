//
//  NewMessage.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 29.10.2021.
//

public struct NewMessage {
    /// произвольный типо обрабатывается на клиентах (можно писать че захотите до 15 символов)
    let type: Raw.MessageType
    /// сам контент
    let content: String
    /// в какой чат
    let chatId: ID

    public init(type: Raw.MessageType, content: String, chatId: ID) {
        self.type = type
        self.content = content
        self.chatId = chatId
    }
}

extension NewMessage: ApiFunction {

    public static var method = "message/send"

    public struct Response: Decodable {
        public let messageId: ID
    }
}
