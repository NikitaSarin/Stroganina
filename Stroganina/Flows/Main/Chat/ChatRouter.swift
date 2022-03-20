//
//  ChatRouter.swift
//  Stroganina
//
//  Created by Alex Shipin on 20.03.2022.
//

protocol ChatRouting {
    func openSearchUser(input: Chat)
}

struct ChatRoutingMock: ChatRouting {
    func openSearchUser(input: Chat) { }
}
