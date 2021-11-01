//
//  MakeChatService.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import NetworkApi

protocol MakeChatServiceProtocol {
    func makeChat(with name: String, users: [User], completion: @escaping (Result<Chat, Error>) -> Void)
}

final class MakeChatService: MakeChatServiceProtocol {
    private let api: Networking
    private let updateCenter: UpdateCenter
    
    init(
        api: Networking,
        updateCenter: UpdateCenter
    ) {
        self.api = api
        self.updateCenter = updateCenter
    }

    func makeChat(with name: String, users: [User], completion: @escaping (Result<Chat, Error>) -> Void) {
        api.perform(NewChat(name: name)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.didMakeChat(with: name, users: users, chatId: response.chatId, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func didMakeChat(
        with name: String,
        users: [User],
        chatId: ID,
        completion: @escaping (Result<Chat, Error>) -> Void
    ) {
        let chat = Chat(
            id: chatId,
            title: name,
            showSenders: true,
            unreadCount: 0,
            lastMessage: nil
        )
        users.forEach { [api] user in
            api.perform(AddUserInChat(chatId: chatId, userId: user.id), completion: { _ in })
        }
        updateCenter.sendNotification([.newChat(chat)])
        completion(.success(chat))
    }
}
