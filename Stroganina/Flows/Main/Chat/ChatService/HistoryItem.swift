//
//  HistoryItem.swift
//  Stroganina
//
//  Created by Alex Shipin on 22.03.2022.
//

enum HistoryItem: Identifiable {
    case new(id: MessageIdentifier.ID?, reverse: Bool)
    case empty(id: MessageIdentifier.ID, reverse: Bool)
    case message(message: MessageWrapper)
    
    var id: String {
        switch self {
        case let .new(id, reverse):
            return "new\(id ?? 0)\(reverse)"
        case let .empty(id, reverse):
            return "empty\(id)\(reverse)"
        case let .message(message):
            return "message\(message.id)"
        }
    }
}
