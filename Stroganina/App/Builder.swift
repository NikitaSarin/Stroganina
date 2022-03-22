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
    let updateCenter: UpdateCenter
    let pushService: PushService

    private let api: Networking
    
    private var chatServises = [Chat.ID: ChatService]()

    init(store: Store) {
        self.store = store
        self.api = Api(config: .default, store: store)
        self.updateCenter = UpdateCenter(api: api)
        self.pushService = PushService(api: api, store: store)
    }

    func buildStartScene(router: AuthRouting) -> UIViewController {
        let view = StartView(router: router)
        return UIHostingController(rootView: view)
    }

    func buildLoginScene(router: AuthRouting) -> UIViewController {
        let service = LoginService(api: api, store: store)
        let viewModel = LoginViewModel(router: router, service: service, pushService: pushService)
        let view = LoginView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }

    func buildRegistrationScene(router: AuthRouting) -> UIViewController {
        let service = RegistrationService(api: api, store: store)
        let viewModel = RegistrationViewModel(router: router, service: service, pushService: pushService)
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
        let service = chatServises[input.id] ?? ChatService(chatId: input.id, api: api, updateCenter: updateCenter)
        chatServises[input.id] = service
        let factory = ChatMessagesFactory()
        let viewModel = ChatViewModel(chat: input, service: service, router: router)
        let view = ChatView(viewModel: viewModel, factory: factory)
        return UIHostingController(rootView: view)
    }

    private func buildChatListScene(router: Router) -> UIViewController {
        let service = ChatListService(api: api, updateCenter: updateCenter)
        let viewModel = ChatListViewModel(router: router, service: service, store: store)
        let view = ChatList(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message"), tag: 0)
        return viewController
    }

    private func buildSettingsScene(router: Router) -> UIViewController {
        let service = SettingsService(api: api, store: store)
        let viewModel = SettingsViewModel(router: router, service: service)
        let view = SettingsView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 0)
        return viewController
    }

    // Все ниже в отдельный билдер

    func buildNewChatRouter(
        type: Chat.ChatType,
        openChatHandler: @escaping (Chat) -> Void
    ) -> NewChatRouter {
        let engine = NewChatEngine(mode: type, api: api)
        let router = NewChatRouter(
            engine: engine,
            builder: self,
            openChatHandler: openChatHandler
        )
        engine.router = router
        return router
    }

    func buildChatSetupScene(handler: ChatSetupOutputHandler) -> UIViewController {
        let viewModel = ChatSetupViewModel(handler: handler)
        let view = ChatSetupView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }

    func buildUserSearchScene(
        multipleUsers: Bool,
        handler: UserSearchOutputHandler
    ) -> UIViewController {
        let service = UserSearchService(api: api)
        let viewModel = UserSearchViewModel(
            multipleUsers: multipleUsers,
            handler: handler,
            service: service
        )
        let view = UserSearchView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }

    func buildAddUsersScene(chat: Chat) -> UIViewController {
        let navigation = UINavigationController()
        let decorator = AddUsersDecorator(api: api, chat: chat) {
            navigation.dismiss(animated: true)
        }
        let service = UserSearchService(api: api)
        let viewModel = UserSearchViewModel(
            multipleUsers: true,
            handler: decorator,
            service: service
        )
        let view = UserSearchView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigation.viewControllers = [viewController]
        return navigation
    }
}
