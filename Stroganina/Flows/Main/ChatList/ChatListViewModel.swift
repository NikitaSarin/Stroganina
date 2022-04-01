//
//  ChatListViewModel.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import Foundation
import SwiftUI

final class ChatListViewModel: ObservableObject {

    @Published var chats = [Chat]()
    @Published var isLoading = false

    private let router: ChatListRouting
    private var service: ChatListServiceProtocol
    private let store: Store

    init(
        router: ChatListRouting,
        service: ChatListServiceProtocol,
        store: Store
    ) {
        self.router = router
        self.service = service
        self.store = store
        self.service.delegate = self
    }

    func start() {
        service.fetchChats()
    }

    func didTap(on chat: Chat) {
        router.openChatScene(chat)
    }

    func newPersonalChatButtonTapped() {
        router.openNewChatScene(type: .personal)
    }

    func newGroupButtonTapped() {
        router.openNewChatScene(type: .group)
    }
}

extension ChatListViewModel: ChatListServiceDelegate {
    func didChange(chats: [Chat]) {
        withAnimation {
            self.isLoading = false
            self.chats = chats
        }
    }
}
