//
//  SafeCodableContainer.swift
//  
//
//  Created by Alex Shipin on 21.03.2022.
//

public struct SafeCodableContainer<T: Decodable>: Decodable {
    public let value: T?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            value = try container.decode(T.self)
        } catch {
            value = nil
        }
    }
}
