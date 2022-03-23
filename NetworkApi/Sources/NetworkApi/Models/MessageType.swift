//
//  MessageTypeRaw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

extension Raw {
    public enum MessageState: Codable {
        case sended
        case failed
        case read
    }

    public enum MessageType: String, Codable, UnknownSafable {
        case text = "TEXT"
        case service = "SYSTEM_TEXT"
        case webURL = "WEB_URL"
        case webContent = "WEB_CONTENT"
        case unknown
    }
}
