//
//  AddUsersDecorator.swift
//  Stroganina
//
//  Created by Nikita Sarin on 21.03.2022.
//

import Foundation
import NetworkApi

// Не совсем декоратор в реализации
// но основная цель таже - расширяет экран поиска юзеров
final class AddUsersDecorator {

    private let api: Networking
    private let chat: Chat
    private var group: DispatchGroup?
    private let onSuccess: () -> Void

    init(
        api: Networking,
        chat: Chat,
        onSuccess: @escaping () -> Void
    ) {
        self.api = api
        self.chat = chat
        self.onSuccess = onSuccess
    }
}

extension AddUsersDecorator: UserSearchOutputHandler {

    func process(output: [User]) {
        let group = DispatchGroup()
        output.forEach { user in
            group.enter()
            let function = AddUserInChat(chatId: chat.id, userId: user.id)
            api.perform(function) { result in
                switch result {
                case .success:
                    group.leave()
                case .failure: break
                }
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.onSuccess()
        }
        self.group = group
    }
}
