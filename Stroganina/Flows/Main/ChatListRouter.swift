//
//  ChatListRouter.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

protocol ChatListRouting {
    func openChatScene(_ chat: Chat)
}

struct ChatListRoutingMock: ChatListRouting {
    func openChatScene(_ chat: Chat) {}
}
