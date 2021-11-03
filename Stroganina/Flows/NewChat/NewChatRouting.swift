//
//  NewChatRouting.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

protocol NewChatRouting {
    func openChatSetupScene(input: [User])
    func openChatScene(input: Chat)
}

struct NewChatRouterMock: NewChatRouting {
    func openChatSetupScene(input: [User]) { }
    func openChatScene(input: Chat) { }
}
