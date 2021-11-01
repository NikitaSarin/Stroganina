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
    private lazy var navigation: UINavigationController = {
        let navigation = UINavigationController()
        navigation.setNavigationBarHidden(true, animated: false)
        navigation.navigationBar.prefersLargeTitles = true
        return navigation
    }()
    private let store: Store

    private var initialViewController: UIViewController {
        if auth.isAuthorized {
            return builder.buildChatListScene(router: self)
        } else {
            return builder.buildStartScene(router: self)
        }
    }
    
    lazy var makeChatRouter = MakeChatRouter(builder: builder) { [weak self] chat in
        self?.openChatScene(chat)
    }

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
        store.load()
        navigation.setViewControllers([initialViewController], animated: false)
        window.rootViewController = navigation
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

    func openMainFlow() {
        let viewController = builder.buildChatListScene(router: self)
        navigation.setViewControllers([viewController], animated: true)
    }
}

extension Router: ChatListRouting {
    func logout() {
        let viewController = builder.buildStartScene(router: self)
        navigation.setViewControllers([viewController], animated: true)
    }
    
    func openChatScene(_ chat: Chat) {
        let viewController = builder.buildChatScene(router: self, input: chat)
        navigation.pushViewController(viewController, animated: true)
    }
    
    func openMakeChatScene() {
        makeChatRouter.start()
        navigation.present(makeChatRouter.navigation, animated: true, completion: nil)
    }
}
