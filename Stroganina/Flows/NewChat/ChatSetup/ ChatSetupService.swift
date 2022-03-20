//
//  ChatSetupService.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import NetworkApi

protocol ChatSetupServiceProtocol {
    func createChat(with name: String, users: [User], completion: @escaping (Result<Chat, Error>) -> Void)
    func createPersonalChat(with user: User, completion: @escaping (Result<Chat, Error>) -> Void)
    func addUsers(in chat: Chat, users: [User])
}

final class ChatSetupService: ChatSetupServiceProtocol {

    private let api: Networking
    private let updateCenter: UpdateCenter

    init(
        api: Networking,
        updateCenter: UpdateCenter
    ) {
        self.api = api
        self.updateCenter = updateCenter
    }

    func createChat(with name: String, users: [User], completion: @escaping (Result<Chat, Error>) -> Void) {
        api.perform(NewChat(name: name)) { [weak self] result in
            switch result {
            case .success(let response):
                let chat = Chat(response)
                self?.addUsers(in: chat, users: users)
                self?.updateCenter.sendNotification(.newChat(chat))
                completion(.success(chat))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func createPersonalChat(with user: User, completion: @escaping (Result<Chat, Error>) -> Void) {
        api.perform(NewPersonalChat(userId: user.id)) { result in
            switch result {
            case .success(let response):
                completion(.success(Chat(response)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addUsers(
        in chat: Chat,
        users: [User]
    ) {
        users.forEach { user in
            api.perform(AddUserInChat(chatId: chat.id, userId: user.id), completion: { _ in })
        }
    }
}

extension ChatSetupService {
    struct Mock: ChatSetupServiceProtocol {
        func createPersonalChat(with user: User, completion: @escaping (Result<Chat, Error>) -> Void) {
            completion(.success(.mock))
        }

        func createChat(
            with name: String,
            users: [User],
            completion: @escaping (Result<Chat, Error>) -> Void
        ) {
            completion(.success(.mock))
        }
        
        func addUsers(
            in chat: Chat,
            users: [User]
        ) {
        }
    }
}
