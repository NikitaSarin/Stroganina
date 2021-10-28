//
//  ChatViewModel.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation

protocol ChatServiceDelegate: AnyObject {
    func didChange(messages: [MessageWrapper])
}

protocol ChatServiceProtocol {
    var allMessagesFetched: Bool { get }
    var delegate: ChatServiceDelegate? { get set }

    func fetch(from messageId: Message.ID?)
}

final class ChatViewModel: ObservableObject {

    @Published var history = [MessageWrapper]()
    let chat: Chat

    private var service: ChatServiceProtocol

    init(
        chat: Chat,
        service: ChatServiceProtocol
    ) {
        self.chat = chat
        self.service = service

        self.service.delegate = self

        fetchHistory()
    }

    func loadNewMessagesIfNeeded() {
        if !service.allMessagesFetched {
            fetchHistory()
        }
    }

    func didTapMessage(with type: MessageWrapper) {
    }

    private func fetchHistory() {
        service.fetch(from: history.last?.id)
    }
}

extension ChatViewModel: ChatServiceDelegate {
    func didChange(messages: [MessageWrapper]) {
        DispatchQueue.main.async {
            self.history = messages
        }
    }
}
