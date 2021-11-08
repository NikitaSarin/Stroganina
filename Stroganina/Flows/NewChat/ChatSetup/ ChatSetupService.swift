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
                self?.didNewChat(raw: response, users: users, completion: completion)
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
    
    private func didNewChat(
        raw: Raw.Chat,
        users: [User],
        completion: @escaping (Result<Chat, Error>) -> Void
    ) {
        let chat = Chat(raw)
        users.forEach { [api] user in
            api.perform(AddUserInChat(chatId: raw.chatId, userId: user.id), completion: { _ in })
        }
        updateCenter.sendNotification(.newChat(chat))
        completion(.success(chat))
    }
}
