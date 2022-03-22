//
//  Notification.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import NetworkApi

enum Notification {
    case newMessage(_ message: Raw.Message)
    case newChat(_ chat: Raw.Chat)
    case closeConnect
}
