//
//  ChatService+Message.swift
//  Stroganina
//
//  Created by Alex Shipin on 22.03.2022.
//

import Foundation

extension ChatService {
    final class MessageNode {
        let messageWrapper: MessageWrapper
        let messageType: MessageType

        private(set) var nextID: MessageIdentifier?
        private(set) var backID: MessageIdentifier?
        
        init(_ messageWrapper: MessageWrapper) {
            self.messageType = messageWrapper.type
            self.messageWrapper = messageWrapper
        }
    }
}

extension ChatService.MessageNode {
    var identifier: MessageIdentifier {
        messageType.base.id
    }

    var actualIdentifier: MessageIdentifier {
        if let remoteId = messageType.base.remoteId {
            return .remote(id: remoteId)
        }
        return identifier
    }

    var remoteID: MessageIdentifier.ID? {
        return messageType.base.remoteId
    }
}

extension ChatService.MessageNode {
    func updateType(_ type: MessageType) {
        self.messageWrapper.type = type
    }
}

extension ChatService.MessageNode {
    func linkNext(_ message: ChatService.MessageNode) {
        guard message.remoteID != nil, self.remoteID != nil else {
            return
        }
        self.nextID = message.identifier
        message.backID = self.identifier
    }

    func linkBack(_ message: ChatService.MessageNode) {
        guard message.remoteID != nil, self.remoteID != nil else {
            return
        }
        self.backID = message.identifier
        message.nextID = self.identifier
    }
}
