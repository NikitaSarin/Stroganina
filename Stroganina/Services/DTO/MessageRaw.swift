//
//  MessageRaw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import Foundation

struct MessageRaw: Codable {
    let user: UserRaw
    let date: UInt
    let content: String
    let messageId: ID
    let chatId: ID
    @SafeCodable var type: MessageTypeRaw
}
