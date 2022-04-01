//
//  Router.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import UIKit

final class Router {

    private let window: UIWindow
    private let builder: Builder
    private let auth: AuthService

    private lazy var root: RootViewController = {
        let root = RootViewController()
        root.content.setNavigationBarHidden(false, animated: false)
        builder.updateCenter.addListener(root)
        return root
    }()
    private var navigation: UINavigationController {
        return root.content
    }
    private let store: Store

    init(
        window: UIWindow,
        builder: Builder
    ) {
        self.window = window
        self.builder = builder
        self.store = builder.store
        self.auth = AuthService(store: builder.store)
    }

    func start() {
        if auth.isAuthorized {
            openMainFlow(animated: false)
        } else {
            openStartScene(animated: false)
        }
        window.rootViewController = root
    }

    func appDidEnterBackground() {
        builder.store.save()
    }
}

extension Router: AuthRouting {
    func openLoginScene() {
        let viewController = builder.buildLoginScene(router: self)
        navigation.pushViewController(viewController, animated: true)
    }

    func openRegistrationScene() {
        let viewController = builder.buildRegistrationScene(router: self)
        navigation.pushViewController(viewController, animated: true)
    }

    func openMainFlow(animated: Bool) {
        builder.updateCenter.start()
        let viewController = builder.buildMainScene(router: self)
        navigation.setViewControllers([viewController], animated: animated)
    }
}

extension Router: ChatListRouting {
    func openChatScene(_ chat: Chat) {
        let viewController = builder.buildChatScene(router: self, input: chat)
        navigation.pushViewController(viewController, animated: true)
    }

    func openNewChatScene(type: Chat.ChatType) {
        let router = builder.buildNewChatRouter(type: type) { [weak self] chat in
            self?.openChatScene(chat)
        }
        router.start()
        navigation.present(router.navigation, animated: true, completion: nil)
    }
}

extension Router: SettingsRouting {
    func openStartScene(animated: Bool) {
        let viewController = builder.buildStartScene(router: self)
        navigation.setViewControllers([viewController], animated: animated)
    }
}

extension Router: ChatRouting {
    func openSearchUser(input: Chat) {
        let viewController = builder.buildAddUsersScene(chat: input)
        navigation.present(viewController, animated: true, completion: nil)
    }
}
