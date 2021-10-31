//
//  MakeChatService.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//


protocol MakeChatServiceProtocol {
    func makeChat(with name: String, users: [User], completion: @escaping (Result<Chat, Error>) -> Void)
}

final class MakeChatService: MakeChatServiceProtocol {
    private let api: Networking
    
    init(api: Networking) {
        self.api = api
    }

    func makeChat(with name: String, users: [User], completion: @escaping (Result<Chat, Error>) -> Void) {
        api.perform(MakeChat(name: name)) { [api] result in
            switch result {
            case .success(let response):
                completion(.success(Chat(
                    id: response.chatId,
                    title: name,
                    showSenders: true,
                    unreadCount: 0,
                    lastMessage: nil
                )))
                users.forEach { user in
                    api.perform(AddUserInChat(chatId: response.chatId, userId: user.id), completion: { _ in })
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
