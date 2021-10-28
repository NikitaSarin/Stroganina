//
//  RequestContainer.swift
//  StroganinaNetwork
//
//  Created by Denis Kamkin on 28.10.2021.
//

import Foundation

struct RequestContainer<Parameters: Encodable>: Encodable {
	let parameters: Parameters
	let token: String?
}
