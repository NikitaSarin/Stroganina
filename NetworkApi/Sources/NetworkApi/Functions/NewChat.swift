//
//  NewChat.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

public struct NewChat {

    let name: String

    public init(name: String) {
        self.name = name
    }
}

extension NewChat: ApiFunction {

    public static var method = "chat/make"

    public typealias Response = Raw.Chat
}
