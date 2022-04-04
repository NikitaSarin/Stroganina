//
//  ChatServisesBuilder.swift
//  Stroganina
//
//  Created by Alex Shipin on 01.04.2022.
//

import NetworkApi

final class ChatServisesBuilder {
    private let updateCenter: UpdateCenter
    private let api: Networking

    private var chatServises = [Chat.ID: ChatServiceProtocol]()

    init(updateCenter: UpdateCenter, api: Networking) {
        self.updateCenter = updateCenter
        self.api = api
    }

    func service(with chatId: Chat.ID) -> ChatServiceProtocol {
        let service = ChatService(chatId: chatId, api: api, updateCenter: updateCenter)
        chatServises[chatId] = service
        return service
    }
}
