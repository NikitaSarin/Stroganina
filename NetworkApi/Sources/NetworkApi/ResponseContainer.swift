//
//  Response.swift
//  Stroganina
//
//  Created by Denis Kamkin on 28.10.2021.
//

import Foundation

struct Response<Content: Decodable>: Decodable {
    let state: ResponseState
    let content: Content?
    let errors: [ResponseError]?
}

enum ResponseState: String, Codable {
    case ok
    case error
}

public struct ResponseError: Codable {
    @SafeCodable public var code: ErrorCode

    /// на информацию из дев инфо завязываться нельзя
    public let developerInfo: DeveloperInfo?

    public struct DeveloperInfo: Codable {
        public let description: String
        public let error: String?
        public let position: Position?

        public struct Position: Codable {
            public let file: String
            public let line: Int
        }
    }

    public enum ErrorCode: String, Codable, UnknownSafable  {
        case unknown
        case methodNotFound

        case alreadyLogin
        case incorrectToken
        case accessError

        case incorrectName
        case nameAlreadyRegistry

        case userAlreadyInChat
        case loginErrors

        case internalError
    }
}

