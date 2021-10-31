//
//  MakeChat.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import Foundation

struct MakeChat {
    let name: String
}

extension MakeChat: ApiFunction {

    static var method = "chat/make"

    struct Response: Decodable {
        let chatId: ID
    }
}
