//
//  GetMessages.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 29.10.2021.
//

public struct GetChats {

    public init() {}
}

extension GetChats: ApiFunction {

    public static var method = "chat/get_all_my"

    public struct Response: Codable {
        public let chats: [Raw.Chat]
    }

}
