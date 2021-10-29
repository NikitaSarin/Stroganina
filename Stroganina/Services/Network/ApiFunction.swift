//
//  ApiFunction.swift
//  Stroganina
//
//  Created by Denis Kamkin on 28.10.2021.
//

import Foundation

protocol ApiFunction: Encodable {
    associatedtype Response: Decodable
    static var method: String { get }
}
