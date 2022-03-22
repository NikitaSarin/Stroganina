//
//  MessageWrapper+Raw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import NetworkApi

extension MessageWrapper {
    convenience init(_ raw: Raw.Message, identifier: MessageIdentifier?) {
        let type = MessageType(raw, identifier: identifier)
        self.init(type: type)
    }
}
