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
    @Published var isLoading = true
    private var service: ChatListServiceProtocol
    private let routing: ChatListRouting
    private let store: Store

    init(
        service: ChatListServiceProtocol,
        store: Store,
        routing: ChatListRouting
    ) {
        self.service = service
        self.routing = routing
        self.store = store
        self.service.delegate = self
    }

    func start() {
        service.fetchChats()
    }

    func didTap(on chat: Chat) {
        routing.openChatScene(chat)
    }

    func newChatButtonTapped() {
        routing.openNewChatScene()
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
