//
//  PlayableMessage.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 28.05.2021.
//

import Combine

class PlayableMessage: BaseMessage {

    let duration: Int

    @Published var url: URL? {
        willSet {
            objectWillChange.send()
        }
    }
    private var loader: SingleFileLoader?

    init(
        base: BaseMessage,
        duration: Int,
        url: URL?,
        loader: SingleFileLoader?
    ) {
        self.duration = duration
        self.url = url
        self.loader = loader
        super.init(base)
    }

    func load() {
        loader?.load { [weak self] path in
            self?.url = URL(fileURLWithPath: path)
        }
    }
}
