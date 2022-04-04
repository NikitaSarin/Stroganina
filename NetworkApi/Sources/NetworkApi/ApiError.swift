//
//  ApiError.swift
//  Stroganina
//
//  Created by Denis Kamkin on 28.10.2021.
//

import Foundation

public enum ApiError: Error {
	case userError(_ error: ResponseError)
	case networkError(_ error: Error)
	case decodingError
    case closeConnect
    case reconnect
}
