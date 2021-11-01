//
//  ApiFunction.swift
//  Stroganina
//
//  Created by Denis Kamkin on 28.10.2021.
//

import Foundation

public protocol ApiFunction: Encodable {
    associatedtype Response: Decodable
    static var method: String { get }
    static var longTimeOut: Bool { get }
}

public extension ApiFunction {
    static var longTimeOut: Bool {
        false
    }
}
