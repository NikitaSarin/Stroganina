//
//  AudioMessage.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.05.2021.
//

import Foundation

final class AudioMessage: PlayableMessage {

    let name: String

    init(
        base: BaseMessage,
        name: String,
        duration: Int,
        url: URL?,
        loader: SingleFileLoader?
    ) {
        self.name = name
        super.init(
            base: base,
            duration: duration,
            url: url,
            loader: loader
        )
    }
}
