//
//  Request.swift
//  StroganinaNetwork
//
//  Created by Denis Kamkin on 28.10.2021.
//

import Foundation

protocol IRequest {
	associatedtype RequestParameters: Encodable
	associatedtype ResponseContent: Decodable

	var method: String { get }
}

struct Request<RequestParameters: Encodable, ResponseContent: Decodable>: IRequest {
	let method: String
}
