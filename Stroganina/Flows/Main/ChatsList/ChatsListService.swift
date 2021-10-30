//
//  ChatsListService.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import Foundation

protocol ChatsListServiceDelegate {
    func didChange(chats: [Chat])
}

protocol ChatsListServiceProtocol {
    var delegate: ChatsListServiceDelegate? { get set }
}

final class ChatsListService: ChatsListServiceProtocol {
    var delegate: ChatsListServiceDelegate? {
        didSet {
            self.sendUpdate()
        }
    }
    
    private let api: Networking
    private var chats = Set<Chat>()
    
    init(api: Networking) {
        self.api = api
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
                return rhsMessage.date > lhsMessage.date
            }
            if lhs.lastMessage == nil && rhs.lastMessage != nil {
                return true
            }
            return false
        })
        delegate?.didChange(chats: chats)
    }
}
