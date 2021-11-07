//
//  File.swift
//  
//
//  Created by Aleksandr Shipin on 07.11.2021.
//

public struct NewPersonalChat {

    let userId: ID

    public init(userId: ID) {
        self.userId = userId
    }
}

extension NewPersonalChat: ApiFunction {

    public static var method = "chat/make_personal"

    public typealias Response = Raw.Chat
}
