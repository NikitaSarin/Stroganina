//
//  ChatRouter.swift
//  Stroganina
//
//  Created by Alex Shipin on 20.03.2022.
//

protocol ChatRouting {
    func openSearchUser(_ selectedUsersHandler: @escaping ([User]) -> Void)
}

struct ChatRoutingMock: ChatRouting {
    func openSearchUser(_ selectedUsersHandler: @escaping ([User]) -> Void) { }
}
