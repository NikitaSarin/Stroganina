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

    private let router: ChatListRouting
    private var service: ChatListServiceProtocol
    private let store: Store
    private var openChatId: Chat.ID?
    private var currentChatId: Chat.ID?

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
        currentChatId = nil
        service.fetchChats()
    }

    func didTap(on chat: Chat) {
        currentChatId = chat.id
        router.openChatScene(chat)
    }

    func newPersonalChatButtonTapped() {
        router.openNewChatScene(type: .personal)
    }

    func newGroupButtonTapped() {
        router.openNewChatScene(type: .group)
    }

    private func openChat(_ chatId: Chat.ID) {
        self.openChatId = chatId
        openPushChat()
    }

    private func openPushChat() {
        guard let openChatId = openChatId, let chat = chats.first(where: { $0.id == openChatId }) else {
            return
        }
        if currentChatId != openChatId {
            currentChatId = chat.id
            router.openChatScene(chat)
        }
        self.openChatId = nil
    }
}

extension ChatListViewModel: ChatListServiceDelegate {
    func didChange(chats: [Chat]) {
        self.isLoading = false
        self.chats =  chats
        openPushChat()
    }
}

extension ChatListViewModel: PushNotificationHandler {
    func canShow(info: PushNotificationInfo) -> Bool {
        info.chatId != currentChatId
    }

    func open(info: PushNotificationInfo) {
        openChat(info.chatId)
    }
}
