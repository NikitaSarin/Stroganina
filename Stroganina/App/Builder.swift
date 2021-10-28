//
//  Builder.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import UIKit
import SwiftUI

final class Builder {

    let store: Store
    let network: Network

    init(store: Store) {
        self.store = store
        self.network = Network(config: .default, store: store)
    }

    func buildChatScene(router: Router) -> UIViewController {
        let service = ChatService(network: network)
        let factory = ChatMessagesFactory()
        let viewModel = ChatViewModel(chat: .mock, service: service)
        let view = ChatView(viewModel: viewModel, factory: factory)
        return UIHostingController(rootView: view)
    }

    func buildStartScene(router: AuthRouting) -> UIViewController {
        let view = StartView(router: router)
        return UIHostingController(rootView: view)
    }

    func buildLoginScene(router: AuthRouting) -> UIViewController {
        let service = LoginService(network: network, store: store)
        let viewModel = LoginViewModel(router: router, service: service)
        let view = LoginView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }

    func buildRegistrationScene(router: AuthRouting) -> UIViewController {
        let service = RegistrationService(store: store)
        let viewModel = RegistrationViewModel(router: router, service: service)
        let view = RegistrationView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
}