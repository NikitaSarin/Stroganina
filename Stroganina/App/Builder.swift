//
//  Builder.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import UIKit
import SwiftUI

final class Builder {

    func buildChatScene(router: Router) -> UIViewController {
        let service = ChatService()
        let factory = ChatMessagesFactory()
        let viewModel = ChatViewModel(chat: .mock, service: service)
        let view = ChatView(viewModel: viewModel, factory: factory)
        return UIHostingController(rootView: view)
    }
}
