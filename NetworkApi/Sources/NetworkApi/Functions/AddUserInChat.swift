//
//  AddUserInChat.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

public struct AddUserInChat {
    let chatId: ID
    let userId: ID

    public init(chatId: ID, userId: ID) {
        self.chatId = chatId
        self.userId = userId
    }
}

extension AddUserInChat: ApiFunction {

    public static var method = "chat/add_user"

    public struct Response: Decodable {
    }
}
