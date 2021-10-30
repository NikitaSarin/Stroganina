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

    @Published var history = [MessageWrapper]()
    @Published var messageText = ""

    private var service: ChatServiceProtocol

    init(
        chat: Chat,
        service: ChatServiceProtocol
    ) {
        self.chat = chat
        self.service = service

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
