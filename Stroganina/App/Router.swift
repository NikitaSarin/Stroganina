//
//  Router.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import UIKit

final class Router {

    private let builder: Builder
    private let auth: AuthService

    private var navigation: Navigation
    private let store: Store

    init(
        navigation: Navigation,
        builder: Builder
    ) {
        self.navigation = navigation
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
    }

    func appDidEnterBackground() {
        builder.store.save()
    }
}

extension Router: AuthRouting {
    func openLoginScene() {
        let screen = builder.buildLoginScene(router: self)
        navigation.pushViewController(screen, animated: true)
    }

    func openRegistrationScene() {
        let screen = builder.buildRegistrationScene(router: self)
        navigation.pushViewController(screen, animated: true)
    }

    func openMainFlow(animated: Bool) {
        builder.updateCenter.start()
        let chatList = builder.buildChatListScene(router: self)
        let settings = builder.buildSettingsScene(router: self)

        navigation.setRoot(animated: false, requredFullScreen: false) { tabNavigation in
            tabNavigation.add(.init(title: "Chat", image: "message", screen: chatList))
            tabNavigation.add(.init(title: "Settings", image: "gear", screen: settings))
        }
    }
}

extension Router: ChatListRouting {
    func openChatScene(_ chat: Chat) {
        let viewController = builder.buildChatScene(router: self, input: chat)
        navigation.pushViewController(viewController, animated: true)
    }

    func openNewChatScene(type: Chat.ChatType) {
        let router = builder.buildNewChatRouter(navigation: navigation, type: type) { [weak self] chat in
            self?.openChatScene(chat)
        }
        router.start()
    }
}

extension Router: SettingsRouting {
    func openStartScene(animated: Bool) {
        let screen = builder.buildStartScene(router: self)
        navigation.setRoot(screen, animated: animated, requredFullScreen: true)
    }
}

extension Router: ChatRouting {
    func openSearchUser(input: Chat) {
        navigation.present(animated: true, completion: nil) { navigation in
            var navigation: Navigation? = navigation
            let screen = builder.buildAddUsersScene(chat: input) {
                navigation?.dismiss(animated: true, completion: nil)
                navigation = nil
            }
            navigation?.setRoot(screen, animated: true, requredFullScreen: true)
        }
    }
}
