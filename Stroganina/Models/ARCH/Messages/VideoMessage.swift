//
//  VideoMessage.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 27.05.2021.
//

import UIKit

final class VideoMessage: PlayableMessage {

    @Published var thumbnail: UIImage? {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var isUnread: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    let size: CGSize
    let text: String

    var messageViewedAction: VoidClosure?

    init(
        base: BaseMessage,
        thumbnail: UIImage?,
        url: URL?,
        duration: Int,
        size: CGSize,
        text: String,
        isUnread: Bool,
        loader: SingleFileLoader?
    ) {
        self.thumbnail = thumbnail
        self.size = size
        self.text = text
        self.isUnread = isUnread
        super.init(
            base: base,
            duration: duration,
            url: url,
            loader: loader
        )
    }
}
