//
//  Request.swift
//  Stroganina
//
//  Created by Denis Kamkin on 28.10.2021.
//

import Foundation

struct Request<Content: Encodable>: Encodable {

    enum CodingKeys: String, CodingKey {
        case time
        case authorisation
        case content = "parameters"
    }

    let time: UInt
    let authorisation: AuthorisationInfo?
    let content: Content
}
