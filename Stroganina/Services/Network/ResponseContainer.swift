//
//  ResponseContainer.swift
//  StroganinaNetwork
//
//  Created by Denis Kamkin on 28.10.2021.
//

import Foundation

struct ResponseContainer<Content: Decodable>: Decodable {
	let state: ResponseContainerState
	let content: Content?
	let error: ResponseContainerError?
}
