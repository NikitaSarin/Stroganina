//
//  ChatService+MessageProvider.swift
//  Stroganina
//
//  Created by Alex Shipin on 22.03.2022.
//

import Foundation

extension ChatService {
    struct MessageProvider {
        let remoteID: MessageIdentifier.ID?
        let makeMessageType: ((_ id: MessageIdentifier) -> MessageType)
        
        init(
            remoteID: MessageIdentifier.ID? = nil,
            makeMessageType: @escaping ((MessageIdentifier) -> MessageType)
        ) {
            self.remoteID = remoteID
            self.makeMessageType = makeMessageType
        }
    }
}
