//
//  Notification.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

enum Notification {
    case newMessage(_ message: MessageWrapper)
    case newChat(_ chat: Chat)
    case closeConnect
}
