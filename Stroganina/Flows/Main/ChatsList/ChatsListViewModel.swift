//
//  ChatsListViewModel.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import Foundation
import SwiftUI

final class ChatsListViewModel: ObservableObject {
    @Published var chats = [Chat]()
    
    private var service: ChatsListServiceProtocol
    private let routing: ChatListRouting

    init(
        service: ChatsListServiceProtocol,
        routing: ChatListRouting
    ) {
        self.service = service
        self.routing = routing
        self.service.delegate = self
    }
    
    func tapInChat(_ chat: Chat) {
        routing.openChatScene(chat)
    }
}

extension ChatsListViewModel: ChatsListServiceDelegate {
    func didChange(chats: [Chat]) {
        DispatchQueue.main.async {
            withAnimation {
                self.chats = chats
            }
        }
    }
}
