//
//  ChatService+Message.swift
//  Stroganina
//
//  Created by Alex Shipin on 22.03.2022.
//

import Foundation

extension ChatService {
    final class MessageContainer {
        let identifier: MessageIdentifier

        lazy var messageWrapper: MessageWrapper = {
            .init(type: provider.makeMessageType(self.identifier))
        }()
        var provider: MessageProvider {
            didSet {
                DispatchQueue.main.async {
                    self.messageWrapper.type = self.provider.makeMessageType(self.identifier)
                }
            }
        }
        
        private(set) var nextID: MessageIdentifier?
        private(set) var backID: MessageIdentifier?
        
        internal init(provider: MessageProvider, identifier: MessageIdentifier?) {
            self.provider = provider
            self.identifier = identifier.generate(provider.remoteID)
        }
    }
}

extension ChatService.MessageContainer {
    var actualIdentifier: MessageIdentifier {
        if let remoteId = provider.remoteID {
            return .remote(id: remoteId)
        }
        return identifier
    }
    
    var remoteID: MessageIdentifier.ID? {
        return provider.remoteID
    }
}

extension ChatService.MessageContainer {
    func linkNext(_ container: ChatService.MessageContainer) {
        guard container.provider.remoteID != nil, self.provider.remoteID != nil else {
            return
        }
        self.nextID = container.identifier
        container.backID = self.identifier
    }
    
    func linkBack(_ container: ChatService.MessageContainer) {
        guard container.provider.remoteID != nil, self.provider.remoteID != nil else {
            return
        }
        self.backID = container.identifier
        container.nextID = self.identifier
    }
}
