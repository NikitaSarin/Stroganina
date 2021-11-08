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
    static var wayType: RequestWayType { get }
}

public protocol ApiListener {
    associatedtype Response: Decodable
    static var method: String { get }
}

extension ApiFunction {
    public static var wayType: RequestWayType {
        .http
    }
}

public enum RequestWayType {
    case http
    case ws
}
