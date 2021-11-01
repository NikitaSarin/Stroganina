//
//  ChatListService.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import Foundation
import NetworkApi

protocol ChatListServiceDelegate {
    func didChange(chats: [Chat])
}

protocol ChatListServiceProtocol {
    var delegate: ChatListServiceDelegate? { get set }
}

final class ChatListService: ChatListServiceProtocol {
    var delegate: ChatListServiceDelegate? {
        didSet {
            self.sendUpdate()
        }
    }
    
    private let api: Networking
    private let updateCenter: UpdateCenter
    private var chats = Set<Chat>()
    
    init(
        api: Networking,
        updateCenter: UpdateCenter
    ) {
        self.api = api
        self.updateCenter = updateCenter
        updateCenter.addListener(self)
        self.update()
    }

    private func update() {
        api.perform(GetChats()) { [weak self] response in
            self?.didLoad(response)
        }
    }
    
    private func didLoad(_ response: Result<GetChats.Response, ApiError>) {
        switch response {
        case .success(let content):
            let chats = content.chats.map { Chat($0) }
            chats.forEach { self.chats.insert($0) }
            sendUpdate()
        case .failure:
            break
        }
    }
    
    private func sendUpdate() {
        let chats = Array(chats).sorted(by: { (lhs: Chat, rhs: Chat) in
            if
                let rhsMessage = rhs.lastMessage?.base,
                let lhsMessage = lhs.lastMessage?.base
            {
                return rhsMessage.date < lhsMessage.date
            }
            if lhs.lastMessage == nil && rhs.lastMessage != nil {
                return false
            }
            return true
        })
        delegate?.didChange(chats: chats)
    }
}

extension ChatListService: Listener {
    func update(_ notifications: [Notification]) {
        var isNeedUpdate: Bool = false
        for notification in notifications {
            switch notification {
            case .newMessage(let message):
                chats.first(where: { $0.id == message.base.chatId })?.lastMessage = message
                isNeedUpdate = true
            case .newChat(let chat):
                chats.insert(chat)
                isNeedUpdate = true
            }
        }
        if isNeedUpdate {
            self.sendUpdate()
        }
    }
}
