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
	let error: ResponseError?
}

enum ResponseState: String, Codable {
    case ok
    case error
}

struct ResponseError: Codable {
    let name: String
    let description: String
    let info: String?
}
