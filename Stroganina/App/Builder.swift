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

    func buildMainScene(router: Router) -> UIViewController {
        let chatList = buildChatListScene(router: router)
        let settings = buildSettingsScene(router: router)
        let tabbar = TabBarController(hideNavigation: true)
        tabbar.viewControllers = [chatList, settings]
        return tabbar
    }

    func buildChatScene(router: Router, input: Chat) -> UIViewController {
        let service = ChatService(chatId: input.id, api: api, updateCenter: updateCenter)
        let factory = ChatMessagesFactory()
        let viewModel = ChatViewModel(chat: input, service: service)
        let view = ChatView(viewModel: viewModel, factory: factory)
        return UIHostingController(rootView: view)
    }

    private func buildChatListScene(router: Router) -> UIViewController {
        let service = ChatListService(api: api, updateCenter: updateCenter)
        let viewModel = ChatListViewModel(service: service, store: store, routing: router)
        let view = ChatList(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message"), tag: 0)
        return viewController
    }

    private func buildSettingsScene(router: Router) -> UIViewController {
        let service = SettingsService(store: store)
        let viewModel = SettingsViewModel(router: router, service: service)
        let view = SettingsView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 0)
        return viewController
    }

    // Все ниже в отдельный билдер

    func buildNewChatScene(router: MakeChatRouter, users: [User]) -> UIViewController {
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
