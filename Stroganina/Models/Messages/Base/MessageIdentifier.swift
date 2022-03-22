import Foundation
import NetworkApi

enum MessageIdentifier: Hashable, Codable {
    typealias ID = NetworkApi.ID

    case local(time: UInt64, id: UInt64)
    case remote(id: ID)
}

extension MessageIdentifier: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.local(let t1, let i1), .local(let t2, let i2)):
            return t1 < t2 || (t1 == t2 && i1 < i2)
        case (.remote(let id1), .remote(let id2)):
            return id1 < id2
        case (.remote, .local):
            return true
        case (.local, .remote):
            return false
        }
    }
    
    static func > (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.local(let t1, let i1), .local(let t2, let i2)):
            return t1 > t2 || (t1 == t2 && i1 > i2)
        case (.remote(let id1), .remote(let id2)):
            return id1 > id2
        case (.remote, .local):
            return false
        case (.local, .remote):
            return true
        }
    }

    static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs < rhs || lhs == rhs
    }

    static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs > rhs || lhs == rhs
    }
}
