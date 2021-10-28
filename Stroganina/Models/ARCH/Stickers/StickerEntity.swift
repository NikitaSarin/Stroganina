//
//  StickerEntity.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 02.06.2021.
//

import TDLib
import UIKit

final class StickerEntity: Identifiable, ObservableObject {

    @Published var thumbnail: UIImage?
    @Published var content: StickerContent?

    let loader: FileLoader?
    let original: Sticker?
    private var requested = false

    init(
        thumbnail: UIImage?,
        content: StickerContent?,
        original: Sticker? = nil,
        loader: FileLoader? = nil
    ) {
        self.thumbnail = thumbnail
        self.content = content
        self.original = original
        self.loader = loader
    }

    func load() {
        guard !requested, thumbnail == nil, content == nil else { return }
        requested = true
        loader?.loadThumbnail(thumbnail: original?.thumbnail) { [weak self] in
            self?.thumbnail = $0
        }
        loader?.loadSticker(sticker: original) { [weak self] in
            self?.content = $0
        }
    }
}
