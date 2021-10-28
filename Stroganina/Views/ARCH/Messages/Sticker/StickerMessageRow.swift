//
//  StickerMessageRow.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 26.05.2021.
//

import SwiftUI

struct StickerMessageRow: View {

    @ObservedObject var viewModel: StickerMessageRowViewModel

    private var stickerSize: CGSize

    init(message: StickerMessage) {
        self.viewModel = StickerMessageRowViewModel(message: message)
        self.stickerSize = prefferedContentSize(for: message.size, maxHeight: 140)
    }

    private var image: UIImage? {
        viewModel.image ?? viewModel.message.thumbnail
    }

    var body: some View {
        Group {
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
                    .onAppear {
                        viewModel.player?.play()
                    }
                    .onDisappear {
                        viewModel.player?.pause()
                    }
            } else {
                Color.clear
            }
        }
        .frame(size: stickerSize)
    }
}

struct StickerMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        StickerMessageRow(
            message: StickerMessage(
                base: .mock(),
                size: .mops,
                thumbnail: nil,
                content: .mock
            )
        )
    }
}

extension UIImage {
    static let mops = UIImage(named: "mops") ?? UIImage()
}

extension CGSize {
    static let mops = CGSize(
        width: 512,
        height: 378
    )
}
