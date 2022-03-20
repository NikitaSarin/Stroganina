//
//  ChatViewModel.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation
import SwiftUI

final class ChatViewModel: ObservableObject {

    let chat: Chat
    
    var isEnabledAddNewUser: Bool {
        chat.chatType == .group
    }

    @Published var history = [MessageWrapper]()
    @Published var messageText = ""

    private var service: ChatServiceProtocol
    private let chatSetupService: ChatSetupServiceProtocol
    private let router: ChatRouting

    init(
        chat: Chat,
        service: ChatServiceProtocol,
        chatSetupService: ChatSetupServiceProtocol,
        router: ChatRouting
    ) {
        self.chat = chat
        self.service = service
        self.chatSetupService = chatSetupService
        self.router = router

        self.service.delegate = self
    }

    func start() {
        service.start()
        reloadHistory()
    }

    func loadNewMessagesIfNeeded() {
        if !service.allMessagesFetched {
            reloadHistory()
        }
    }

    func reloadHistory() {
        service.fetch(from: history.last?.id)
    }
    
    func addUsersInChat() {
        router.openSearchUser { [weak self, chat] users in
            self?.chatSetupService.addUsers(in: chat, users: users)
        }
    }
}

extension ChatViewModel: ChatServiceDelegate {
    func didChange(messages: [MessageWrapper]) {
        DispatchQueue.main.async {
            withAnimation {
                self.history = messages
            }
        }
    }
}

extension ChatViewModel: SendMessagePanelDelegate {
    func sendButtonTapped() {
        service.send(text: messageText) { [weak self] success in
            self?.messageText = ""
        }
    }
}
