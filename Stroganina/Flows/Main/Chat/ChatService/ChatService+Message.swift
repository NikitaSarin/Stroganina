//
//  ChatService+Message.swift
//  Stroganina
//
//  Created by Alex Shipin on 22.03.2022.
//

import Foundation

extension ChatService {
    final class MessageContainer {
        let messageWrapper: MessageWrapper

        var messageType: MessageType {
            didSet {
                DispatchQueue.main.async {
                    self.messageWrapper.type = self.messageType
                }
            }
        }

        private(set) var nextID: MessageIdentifier?
        private(set) var backID: MessageIdentifier?
        
        internal init(messageWrapper: MessageWrapper) {
            self.messageType = messageWrapper.type
            self.messageWrapper = messageWrapper
        }
    }
}

extension ChatService.MessageContainer {
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

extension ChatService.MessageContainer {
    func updateType(_ type: MessageType) {
        self.messageWrapper.type = type
    }
}

extension ChatService.MessageContainer {
    func linkNext(_ container: ChatService.MessageContainer) {
        guard container.remoteID != nil, self.remoteID != nil else {
            return
        }
        self.nextID = container.identifier
        container.backID = self.identifier
    }
    
    func linkBack(_ container: ChatService.MessageContainer) {
        guard container.remoteID != nil, self.remoteID != nil else {
            return
        }
        self.backID = container.identifier
        container.nextID = self.identifier
    }
}
