//
//  NewChatRouter.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import UIKit

final class NewChatRouter {

    private(set) var navigation: Navigation?

    private let root: Navigation
    private let engine: NewChatEngine
    private let builder: Builder
    private let openChatHandler: (Chat) -> Void

    init(
        root: Navigation,
        engine: NewChatEngine,
        builder: Builder,
        openChatHandler: @escaping (Chat) -> Void
    ) {
        self.root = root
        self.engine = engine
        self.builder = builder
        self.openChatHandler = openChatHandler
    }

    func start() {
        engine.run()
    }
}

extension NewChatRouter: NewChatRouting {
    func openUserSearchScene(multipleUsers: Bool) {
        let searchScene = builder.buildUserSearchScene(multipleUsers: multipleUsers, handler: self)
        root.present(animated: true, completion: nil) { navigation in
            navigation.setRoot(searchScene, animated: false, requredFullScreen: false)
            self.navigation = navigation
        }
    }

    func openChatSetupScene() {
        let viewController = builder.buildChatSetupScene(handler: self)
        navigation?.pushViewController(viewController, animated: true)
    }

    func openChatScene(input: Chat) {
        navigation?.dismiss(animated: true, completion: nil)
        openChatHandler(input)
    }
}

extension NewChatRouter: UserSearchOutputHandler {

    func process(output: [User]) {
        engine.receive(input: .users(output), completion: nil)
    }
}

extension NewChatRouter: ChatSetupOutputHandler {
    func process(output name: String) {
        engine.receive(input: .name(name), completion: nil)
    }
}
