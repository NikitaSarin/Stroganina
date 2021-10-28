//
//  VideoNoteMessageRow.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 28.05.2021.
//

import SwiftUI

struct VideoNoteMessageRow: View {

    @ObservedObject var viewModel: VideoViewModel
    private let side: CGFloat

    init(
        message: VideoMessage,
        side: CGFloat = 140
    ) {
        self.viewModel = VideoViewModel(message: message)
        self.side = side
    }

    var dotOffset: CGFloat {
        if side > 140 {
            return 0
        } else {
            return viewModel.message.isUnread  ? 13 : 0
        }
    }

    var body: some View {
        ZStack {
            ZStack {
                Video(
                    url: $viewModel.message.url,
                    thumbnail: $viewModel.thumbnail,
                    isPlaying: $viewModel.isPlaying,
                    size: viewModel.videoSize
                )
                if viewModel.isPlaying {
                    AnimatedCircle(progress: $viewModel.progress)
                        .padding(6)
                        .onAppear {
                            viewModel.message.messageViewedAction?()
                            viewModel.message.isUnread = false
                        }
                }
            }
            .frame(side: side)
            .cornerRadius(side / 2)
            .padding(.trailing, dotOffset)
            if !viewModel.isPlaying {
                duration
            }
        }
        .frame(width: side + dotOffset, height: side)
    }

    var duration: some View {
        VStack {
            Spacer()
            HStack(spacing: 4) {
                Spacer()
                Text(viewModel.duration)
                    .foregroundColor(.tg_grey)
                    .font(.medium(size: 13))
                if viewModel.message.isUnread {
                    BlueDot()
                }
            }
        }
    }
}

struct VideoNoteMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        VideoNoteMessageRow(
            message: VideoMessage(
                base: .mock(),
                thumbnail: .mops,
                url: nil,
                duration: 260,
                size: .mops,
                text: "Hello",
                isUnread: true,
                loader: nil
            )
        )
    }
}
