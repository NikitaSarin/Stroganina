//
//  AddUserInChat.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import Foundation

struct AddUserInChat {
    let chatId: ID
    let userId: ID
}

extension AddUserInChat: ApiFunction {

    static var method = "chat/add_user"

    struct Response: Decodable {
    }
}
