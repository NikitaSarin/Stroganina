//
//  NewMessage.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 29.10.2021.
//

import Foundation

struct NewMessage {
    /// произвольный типо обрабатывается на клиентах (можно писать че захотите до 15 символов)
    let type: MessageTypeRaw
    /// сам контент
    let content: String
    /// в какой чат
    let chatId: Chat.ID
}

extension NewMessage: ApiFunction {

    static var method = "message/send"

    struct Response: Decodable {
        let messageId: Message.ID
    }
}
