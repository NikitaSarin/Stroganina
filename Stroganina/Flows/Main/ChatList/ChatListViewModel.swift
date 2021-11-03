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
    
    func didTap(on chat: Chat) {
        routing.openChatScene(chat)
    }

    func NewChatButtonTapped() {
        routing.openNewChatScene()
    }
}

extension ChatListViewModel: ChatListServiceDelegate {
    func didChange(chats: [Chat]) {
        DispatchQueue.main.async {
            withAnimation {
                self.chats = chats
            }
        }
    }
}
