//
//  GetMessages.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 29.10.2021.
//

import Foundation

struct GetChats {
}

extension GetChats: ApiFunction {

    static var method = "chat/get_all_my"

    struct Response: Codable {
        let chats: [ChatRaw]
    }

}
