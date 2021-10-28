//
//  NetworkServiceError.swift
//  StroganinaNetwork
//
//  Created by Denis Kamkin on 28.10.2021.
//

import Foundation

enum NetworkServiceError: Error {
	case userError(_ error: ResponseContainerError)
	case networkError(_ error: Error)
	case decodingError
}
