//
//  Builder.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import UIKit
import SwiftUI

final class Builder {

    let store: Store
    private let api: Networking

    init(store: Store) {
        self.store = store
        self.api = Api(config: .default, store: store)
    }

    func buildChatScene(router: Router, input: Chat) -> UIViewController {
        let service = ChatService(chatId: input.id, api: api)
        let factory = ChatMessagesFactory()
        let viewModel = ChatViewModel(chat: input, service: service)
        let view = ChatView(viewModel: viewModel, factory: factory)
        return UIHostingController(rootView: view)
    }

    func buildStartScene(router: AuthRouting) -> UIViewController {
        let view = StartView(router: router)
        return UIHostingController(rootView: view)
    }

    func buildLoginScene(router: AuthRouting) -> UIViewController {
        let service = LoginService(api: api, store: store)
        let viewModel = LoginViewModel(router: router, service: service)
        let view = LoginView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }

    func buildRegistrationScene(router: AuthRouting) -> UIViewController {
        let service = RegistrationService(api: api, store: store)
        let viewModel = RegistrationViewModel(router: router, service: service)
        let view = RegistrationView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
    
    func buildChatsListScene(router: ChatListRouting) -> UIViewController {
        let service = ChatsListService(api: api)
        let factory = ChatMessagesFactory()
        let viewModel = ChatsListViewModel(service: service, store: store, routing: router)
        let view = ChatsListView(viewModel: viewModel, factory: factory)
        return UIHostingController(rootView: view)
    }
}
