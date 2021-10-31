//
//  MakeChatRouter.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import UIKit

final class MakeChatRouter {
    lazy var navigation: UINavigationController = {
        let navigation = UINavigationController()
        navigation.setNavigationBarHidden(true, animated: false)
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
        let viewController = builder.buildUsersSearchScene(router: self)
        navigation.setViewControllers([viewController], animated: false)
    }
}

extension MakeChatRouter: MakeChatRouting {
    func close() {
        navigation.dismiss(animated: true)
    }

    func openMakeChatScreen(with users: [User]) {
        let viewController = builder.buildMakeChatScene(router: self, users: users)
        navigation.pushViewController(viewController, animated: true)
    }
    
    func openMakeChat(_ chat: Chat) {
        self.openChatHandler(chat)
        navigation.dismiss(animated: true)
    }
}
