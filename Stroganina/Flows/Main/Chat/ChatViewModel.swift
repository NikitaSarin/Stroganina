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

    @Published var history = [HistoryItem]()
    @Published var messageText = ""

    private var service: ChatServiceProtocol
    private let router: ChatRouting

    init(
        chat: Chat,
        service: ChatServiceProtocol,
        router: ChatRouting
    ) {
        self.chat = chat
        self.service = service
        self.router = router
    }

    func start() {
        service.load { [weak self] items in
            DispatchQueue.main.async {
                withAnimation {
                    self?.history = items
                }
            }
        }
    }

    func viewDidShow(_ item: HistoryItem) {
        service.viewDidShow(item)
    }

    func addUsersInChat() {
        router.openSearchUser(input: chat)
    }
}

extension ChatViewModel: SendMessagePanelDelegate {
    func sendButtonTapped() {
        service.send(text: messageText)
        messageText = ""
    }
}
