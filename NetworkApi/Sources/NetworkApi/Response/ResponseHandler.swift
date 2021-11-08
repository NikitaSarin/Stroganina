//
//  ResponseHandler.swift
//  
//
//  Created by Aleksandr Shipin on 05.11.2021.
//

import Foundation

protocol ResponseHandler: AnyObject {
    var identifeir: ResponseHandlerIdentifier { get }

    func handler(data: Data?, error: Error?)
}

enum ResponseHandlerIdentifier {
    // можно удалить только вручную
    case listener(method: String)

    // после обработки будет удален
    case request(reuestId: String)
}

extension ResponseHandlerIdentifier: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .listener(let method):
            hasher.combine(method)
            hasher.combine(1)
        case .request(let reuestId):
            hasher.combine(reuestId)
            hasher.combine(2)
        }
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.listener(let lhs), .listener(let rhs)):
            return lhs == rhs
        case (.request(let lhs), .request(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}
