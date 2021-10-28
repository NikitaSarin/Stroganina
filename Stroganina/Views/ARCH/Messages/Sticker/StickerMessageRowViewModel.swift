//
//  StickerMessageRowViewModel.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 26.05.2021.
//

import UIKit
import Combine

final class StickerMessageRowViewModel: ObservableObject {

    @Published var image: UIImage?
    @Published var message: StickerMessage

    private var cancellable: Cancellable?

    private(set) var player: StickerPlayer?

    init(message: StickerMessage) {
        self.message = message
        self.cancellable = message.$content.sink { [weak self] in
            guard let content = $0 else { return }
            self?.player = StickerPlayer(content: content) { [weak self] in
                self?.image = $0
            }
        }
    }
}
