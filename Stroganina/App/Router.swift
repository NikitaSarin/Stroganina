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

    init(
        window: UIWindow,
        builder: Builder
    ) {
        self.window = window
        self.builder = builder
    }

    func start() {
        window.rootViewController = builder.buildChatScene(router: self)
    }
}
