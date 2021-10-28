//
//  DocumentMessage.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 27.05.2021.
//

import UIKit

final class DocumentMessage: BaseMessage {

    let name: String
    let size: String

    init(
        base: BaseMessage,
        name: String,
        size: String
    ) {
        self.name = name
        self.size = size
        super.init(base)
    }
}
