//
//  MessageIdentifier+Raw.swift
//  Stroganina
//
//  Created by Alex Shipin on 22.03.2022.
//

import NetworkApi
import Foundation

extension MessageIdentifier {
    static func make(with raw: ID? = nil) -> MessageIdentifier {
        if let remoteID = raw {
            return .remote(id: .init(remoteID))
        } else {
            return .nextLocalIdentifier
        }
    }
}

extension Optional where Wrapped == MessageIdentifier {
    func generate(_ raw: ID? = nil) -> MessageIdentifier {
        if let identifier = self {
            return identifier
        } else if let remoteID = raw {
            return .remote(id: .init(remoteID))
        } else {
            return .nextLocalIdentifier
        }
    }
}

extension MessageIdentifier {
    private static let workQueue = DispatchQueue(label: "ChatService.Message.workQueue")
    private static var localCount: UInt64 = 0
    
    fileprivate static var nextLocalIdentifier: MessageIdentifier {
        var id: UInt64 = 0
        workQueue.sync {
            id = localCount
            localCount += 1
        }
        return .local(time: UInt64(Int64(Date().timeIntervalSince1970)), id: id)
    }
}
