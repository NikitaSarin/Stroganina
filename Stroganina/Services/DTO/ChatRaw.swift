//
//  ChatRaw.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import Foundation

struct ChatRaw: Codable {
    let name: String
    let chatId: ID
    let isPersonal: Bool
    let message: MessageRaw?
    let lastMessageId: ID?
    let notReadCount: Int?
}
