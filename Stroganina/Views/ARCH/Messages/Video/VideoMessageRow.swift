//
//  VideoMessageRow.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 27.05.2021.
//

import SwiftUI
import TDLib

struct VideoMessageRow: View {

    @ObservedObject var viewModel: VideoViewModel
    let isOutgoing: Bool

    init(
        message: VideoMessage,
        isOutgoing: Bool? = nil
    ) {
        self.viewModel = VideoViewModel(message: message)
        self.isOutgoing = isOutgoing ?? message.isOutgoing
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                Video(
                    url: $viewModel.message.url,
                    thumbnail: $viewModel.thumbnail,
                    isPlaying: $viewModel.isPlaying,
                    size: viewModel.videoSize
                )
                if viewModel.isPlaying {
                    VStack {
                        Spacer()
                        AnimatedLine(progress: $viewModel.progress)
                            .padding(.horizontal, 12)
                            .padding(.bottom, 13)
                    }
                } else {
                    duration
                }
            }
            .frame(size: viewModel.videoSize)
            if !viewModel.message.text.isEmpty {
                Text(viewModel.message.text)
                    .bubble(isOutgoing: isOutgoing)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
            }
        }
        .background(BubbleStyle.plain.backgroundColor(isOutgoing: isOutgoing))
        .cornerRadius(14)
    }

    var duration: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(viewModel.duration)
                    .foregroundColor(.tg_white)
                    .font(.medium(size: 13))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.tg_white25)
                    .cornerRadius(10)
                    .padding(6)
            }
        }
    }
}

struct VideoMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        VideoMessageRow(
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
