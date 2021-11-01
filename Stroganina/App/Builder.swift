//
//  Builder.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import UIKit
import SwiftUI
import NetworkApi

final class Builder {

    let store: Store
    private let api: Networking
    private let updateCenter: UpdateCenter

    init(store: Store) {
        self.store = store
        self.api = Api(config: .default, store: store)
        self.updateCenter = UpdateCenter(api: api)
    }

    func buildChatScene(router: Router, input: Chat) -> UIViewController {
        let service = ChatService(chatId: input.id, api: api, updateCenter: updateCenter)
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
    
    func buildChatListScene(router: ChatListRouting) -> UIViewController {
        let service = ChatListService(api: api, updateCenter: updateCenter)
        let viewModel = ChatListViewModel(service: service, store: store, routing: router)
        let view = ChatList(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
    
    func buildMakeChatScene(router: MakeChatRouter, users: [User]) -> UIViewController {
        let service = MakeChatService(api: api, updateCenter: updateCenter)
        let viewModel = MakeChatViewModel(users: users, router: router, service: service)
        let view = MakeChatView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
    
    func buildUsersSearchScene(router: MakeChatRouter) -> UIViewController {
        let service = UsersSearchService(api: api)
        let viewModel = UsersSearchViewModel(service: service, router: router)
        let view = UsersSearchView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
}
