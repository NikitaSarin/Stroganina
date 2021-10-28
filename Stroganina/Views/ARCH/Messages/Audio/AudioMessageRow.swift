//
//  AudioMessageRow.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 28.05.2021.
//

import SwiftUI

struct AudioMessageRow: View {

    @ObservedObject var viewModel: AudioViewModel
    @ObservedObject var message: AudioMessage

    let isOutgoing: Bool

    init(
        message: AudioMessage,
        isOutgoing: Bool? = nil
    ) {
        self.message = message
        self.viewModel = AudioViewModel(message: message)
        self.isOutgoing = isOutgoing ?? message.isOutgoing
    }
    
    var body: some View {
        HStack(spacing: 8) {
            PlayButton(
                isPlaying: $viewModel.isPlaying,
                isOutgoing: isOutgoing
            )
            VStack(alignment: .leading, spacing: 2) {
                Text(message.name)
                    .font(.reqular(size: 17))
                Text(viewModel.duration)
                    .font(.reqular(size: 14))
            }
            .foregroundColor(isOutgoing ? .tg_white : .tg_black)
            .lineLimit(1)
        }
        .padding(.vertical, 4)
    }
}

struct AudioMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        Bubble(message: .mock()) {
            AudioMessageRow(
                message: AudioMessage(
                    base: .mock(),
                    name: "l00000000000",
                    duration: 260,
                    url: nil,
                    loader: nil
                )
            )
        }
    }
}
