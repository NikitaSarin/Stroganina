//
//  ResponseContainerError.swift
//  StroganinaNetwork
//
//  Created by Denis Kamkin on 28.10.2021.
//

import Foundation

struct ResponseContainerError: Codable {
	let name: String
	let description: String
	let info: String?
}
