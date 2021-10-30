//
//  SafeCodable.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import Foundation

@propertyWrapper
struct SafeCodable<T: Codable & UnknownSafable>: Codable {

    public let wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            wrappedValue = try container.decode(T.self)
        } catch {
            wrappedValue = T.unknown
        }
    }

    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

public protocol UnknownSafable {
    static var unknown: Self { get }
}
