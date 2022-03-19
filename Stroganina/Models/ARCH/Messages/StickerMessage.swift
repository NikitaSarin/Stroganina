//
//  StickerMessage.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 26.05.2021.
//

import UIKit
import TDLib

struct StickerContent {
    enum Mode {
        case `static`(image: UIImage)
        case animated(data: Data)
    }

    let id: Int
    let mode: Mode
}

extension StickerContent {
    static let mock = StickerContent(id: 1, mode: .static(image: .mops))
}

final class StickerMessage: BaseMessage {

    let size: CGSize

    @Published var thumbnail: UIImage? {
        willSet {
            objectWillChange.send()
        }
    }

    @Published var content: StickerContent? {
        willSet {
            objectWillChange.send()
        }
    }

    init(
        base: BaseMessage,
        size: CGSize,
        thumbnail: UIImage?,
        content: StickerContent?
    ) {
        self.size = size
        self.thumbnail = thumbnail
        self.content = content
        super.init(base)
    }
}
