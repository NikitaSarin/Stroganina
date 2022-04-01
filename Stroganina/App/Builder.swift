//
//  Builder.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import SwiftUI
import NetworkApi

final class Builder {

    let store: Store
    let updateCenter: UpdateCenter
    let pushService: PushService

    private let api: Networking
    private lazy var chatServisesBuilder: ChatServisesBuilder = {
        ChatServisesBuilder(updateCenter: updateCenter, api: api)
    }()
    
    private var chatServises = [Chat.ID: ChatService]()

    init(store: Store) {
        self.store = store
        self.api = Api(config: .default, store: store)
        self.updateCenter = UpdateCenter(api: api)
        self.pushService = PushService(api: api, store: store)
    }

    func buildStartScene(router: AuthRouting) -> some IScreenView {
        ScreenView(StartView(router: router), navigationBarConfig: .init(hidden: true))
    }

    func buildLoginScene(router: AuthRouting) -> some IScreenView {
        let service = LoginService(api: api, store: store)
        let viewModel = LoginViewModel(router: router, service: service, pushService: pushService)
        let view = LoginView(viewModel: viewModel)
        return ScreenView(view)
    }

    func buildRegistrationScene(router: AuthRouting) -> some IScreenView {
        let service = RegistrationService(api: api, store: store)
        let viewModel = RegistrationViewModel(router: router, service: service, pushService: pushService)
        let view = RegistrationView(viewModel: viewModel)
        return ScreenView(view)
    }

    func buildChatScene(router: Router, input: Chat) -> some IScreenView {
        let service = chatServisesBuilder.service(with: input.id)
        let factory = ChatMessagesFactory()
        let viewModel = ChatViewModel(chat: input, service: service, router: router)
        let view = ChatView(viewModel: viewModel, factory: factory)
        return ScreenView(view)
    }

    func buildChatListScene(router: Router) -> some IScreenView {
        let service = ChatListService(api: api, updateCenter: updateCenter)
        let viewModel = ChatListViewModel(router: router, service: service, store: store)
        let view = ChatList(viewModel: viewModel)
        return ScreenView(view)
    }

    func buildSettingsScene(router: Router) -> some IScreenView {
        let service = SettingsService(api: api, store: store)
        let viewModel = SettingsViewModel(router: router, service: service)
        let view = SettingsView(viewModel: viewModel)
        return ScreenView(view, navigationBarConfig: .init(hidden: true))
    }

    // Все ниже в отдельный билдер

    func buildNewChatRouter(
        navigation: Navigation,
        type: Chat.ChatType,
        openChatHandler: @escaping (Chat) -> Void
    ) -> NewChatRouter {
        let engine = NewChatEngine(mode: type, api: api)
        let router = NewChatRouter(
            root: navigation,
            engine: engine,
            builder: self,
            openChatHandler: openChatHandler
        )
        engine.router = router
        return router
    }

    func buildChatSetupScene(handler: ChatSetupOutputHandler) -> some IScreenView {
        let viewModel = ChatSetupViewModel(handler: handler)
        let view = ChatSetupView(viewModel: viewModel)
        return ScreenView(view)
    }

    func buildUserSearchScene(
        multipleUsers: Bool,
        handler: UserSearchOutputHandler
    ) -> some IScreenView {
        let service = UserSearchService(api: api)
        let viewModel = UserSearchViewModel(
            multipleUsers: multipleUsers,
            handler: handler,
            service: service
        )
        let view = UserSearchView(viewModel: viewModel)
        return ScreenView(view)
    }

    func buildAddUsersScene(chat: Chat, closeHandler: @escaping () -> Void) -> some IScreenView {
        let decorator = AddUsersDecorator(api: api, chat: chat) {
            closeHandler()
        }
        let service = UserSearchService(api: api)
        let viewModel = UserSearchViewModel(
            multipleUsers: true,
            handler: decorator,
            service: service
        )
        let view = UserSearchView(viewModel: viewModel)
        return ScreenView(view)
    }
}
