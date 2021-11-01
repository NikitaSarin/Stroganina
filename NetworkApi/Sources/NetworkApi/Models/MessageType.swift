//
//  MessageTypeRaw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

extension Raw {
    public enum MessageType: String, Codable, UnknownSafable {
        case text = "TEXT"
        case service = "SYSTEM_TEXT"
        case unknown
    }
}
