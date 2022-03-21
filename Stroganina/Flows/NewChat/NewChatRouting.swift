//
//  NewChatRouting.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

protocol NewChatRouting: AnyObject {
    func openUserSearchScene(multipleUsers: Bool)
    func openChatSetupScene()
    func openChatScene(input: Chat)
}

final class NewChatRouterMock: NewChatRouting {
    func openUserSearchScene(multipleUsers: Bool) {}
    func openChatSetupScene() { }
    func openChatScene(input: Chat) { }
}
