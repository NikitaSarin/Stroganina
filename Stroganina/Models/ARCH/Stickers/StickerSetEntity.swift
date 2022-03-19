//
//  StickerSetEntity.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 02.06.2021.
//

import TDLib
import UIKit

final class StickerSetEntity: Identifiable, ObservableObject {

    let id: Int64
    let name: String
    @Published var thumbnail: UIImage?
    var stickers: [StickerEntity]
    let loader: FileLoader?
    let originalThumbnail: Thumbnail?
    private var requested = false

    init(
        id: Int64,
        name: String,
        thumbnail: UIImage?,
        stickers: [StickerEntity] = [],
        loader: FileLoader? = nil,
        originalThumbnail: Thumbnail? = nil
    ) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.stickers = stickers
        self.loader = loader
        self.originalThumbnail = originalThumbnail
    }

    func loadThumbnail() {
        guard !requested, thumbnail == nil else { return }
        requested = true
        loader?.loadThumbnail(thumbnail: originalThumbnail) { [weak self] in
            self?.thumbnail = $0
        }
    }
}
