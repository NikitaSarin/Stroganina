//
//  MessageTypeRaw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import Foundation

enum MessageTypeRaw: String, Codable, UnknownSafable {
    case text = "TEXT"
    case service = "SYSTEM_TEXT"
    case unknown
}
