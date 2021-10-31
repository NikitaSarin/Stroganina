//
//  MakeChatRouting.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

protocol MakeChatRouting {
    func openMakeChatScreen(with users: [User])
    func openMakeChat(_ chat: Chat)
    func close()
}

struct MakeChatRoutingMock: MakeChatRouting {
    func openMakeChatScreen(with users: [User]) { }
    func openMakeChat(_ chat: Chat) { }
    func close() { }
}
