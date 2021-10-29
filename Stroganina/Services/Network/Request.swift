//
//  Request.swift
//  Stroganina
//
//  Created by Denis Kamkin on 28.10.2021.
//

import Foundation

struct Request<Content: Encodable>: Encodable {

    enum CodingKeys: String, CodingKey {
        case token
        case content = "parameters"
    }

    let token: String?
    let content: Content
}
