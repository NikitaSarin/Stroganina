//
//  NewChatEngine.swift
//  Stroganina
//
//  Created by Nikita Sarin on 20.03.2022.
//

import NetworkApi
import Foundation

protocol NewChatEventReceiver {
    func receive(input: NewChatEngine.Input, completion: ((Result<Void, Error>) -> Void)?)
}

final class NewChatEngine {

    enum Input {
        case users([User])
        case name(String)
    }

    weak var router: NewChatRouting?

    private let mode: Chat.ChatType
    private let api: Networking
    private var users = [User]()
    private let group = DispatchGroup()

    init(
        mode: Chat.ChatType,
        api: Networking
    ) {
        self.mode = mode
        self.api = api
    }

    func run() {
        router?.openUserSearchScene(multipleUsers: mode != .personal)
    }
}

extension NewChatEngine: NewChatEventReceiver {

    func receive(
        input: NewChatEngine.Input,
        completion: ((Result<Void, Error>) -> Void)?
    ) {
        switch input {
        case .users(let users):
            switch mode {
            case .personal:
                createPersonalChat(with: users.first, completion: completion)
            case .group:
                self.users = users
                router?.openChatSetupScene()
            case .unknown:
                assertionFailure("Unknown chat type!")
            }
        case .name(let name):
            createGroup(name: name, completion: completion)
        }
    }
}

private extension NewChatEngine {
    func createPersonalChat(with user: User?, completion: ((Result<Void, Error>) -> Void)?) {
        guard let user = user else { return }
        let function = NewPersonalChat(userId: user.id)
        api.perform(function) { [weak self] result in
            switch result {
            case .success(let response):
                let chat = Chat(response)
                completion?(.success(()))
                self?.router?.openChatScene(input: chat)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func createGroup(
        name: String,
        completion: ((Result<Void, Error>) -> Void)?
    ) {
        let function = NewChat(name: name)
        api.perform(function) { [weak self] result in
            switch result {
            case .success(let response):
                let chat = Chat(response)
                self?.addUsers(in: chat, completion: completion)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func addUsers(
        in chat: Chat,
        completion: ((Result<Void, Error>) -> Void)?
    ) {
        users.forEach { user in
            group.enter()
            let function = AddUserInChat(chatId: chat.id, userId: user.id)
            api.perform(function) { [weak self] result in
                switch result {
                case .success:
                    self?.group.leave()
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        }
        group.notify(queue: .main) { [weak self] in
            completion?(.success(()))
            self?.router?.openChatScene(input: chat)
        }
    }
}

extension NewChatEngine {
    struct Mock: NewChatEventReceiver {
        func receive(
            input: NewChatEngine.Input,
            completion: ((Result<Void, Error>) -> Void)?
        ) { }
    }
}
