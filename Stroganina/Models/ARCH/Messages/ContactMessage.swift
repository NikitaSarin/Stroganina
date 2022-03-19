//
//  ContactMessage.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 27.05.2021.
//

import UIKit

final class ContactMessage: BaseMessage {

    let name: String
    let phone: String
    var image: UIImage? {
        willSet {
            objectWillChange.send()
        }
    }

    init(
        base: BaseMessage,
        name: String,
        phone: String,
        image: UIImage?
    ) {
        self.name = name
        self.phone = phone
        self.image = image
        super.init(base)
    }
}
