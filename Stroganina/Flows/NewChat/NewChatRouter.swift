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

    private let builder: Builder
    private let openChatHandler: (Chat) -> Void

    init(
        builder: Builder,
        openChatHandler: @escaping (Chat) -> Void
    ) {
        self.builder = builder
        self.openChatHandler = openChatHandler
    }
    
    func start() {
        let viewController = builder.buildUserSearchScene(router: self)
        navigation.setViewControllers([viewController], animated: false)
    }
}

extension NewChatRouter: NewChatRouting {
    func openChatSetupScene(input: [User]) {
        let viewController = builder.buildChatSetupScene(router: self, users: input)
        navigation.pushViewController(viewController, animated: true)
    }

    func openChatScene(input: Chat) {
        navigation.dismiss(animated: true, completion: nil)
        openChatHandler(input)
    }
}
