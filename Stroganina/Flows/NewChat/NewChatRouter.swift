//
//  NewChatRouter.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import UIKit

final class NewChatRouter {

    private(set) lazy var navigation: UINavigationController = {
        let navigation = UINavigationController()
        return navigation
    }()

    private let engine: NewChatEngine
    private let builder: Builder
    private let openChatHandler: (Chat) -> Void

    init(
        engine: NewChatEngine,
        builder: Builder,
        openChatHandler: @escaping (Chat) -> Void
    ) {
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
        let viewController = builder.buildUserSearchScene(multipleUsers: multipleUsers, handler: self)
        navigation.setViewControllers([viewController], animated: false)
    }

    func openChatSetupScene() {
        let viewController = builder.buildChatSetupScene(handler: self)
        navigation.pushViewController(viewController, animated: true)
    }

    func openChatScene(input: Chat) {
        navigation.dismiss(animated: true, completion: nil)
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
