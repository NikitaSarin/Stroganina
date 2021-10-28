//
//  VoiceNoteMessageRow.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 28.05.2021.
//

import SwiftUI

struct VoiceNoteMessageRow: View {

    @ObservedObject var viewModel: AudioViewModel
    @ObservedObject var message: VoiceMessage
    let isOutgoing: Bool

    init(
        message: VoiceMessage,
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
                Waveform(
                    bytes: message.waveform,
                    isOutgoing: isOutgoing,
                    isPlaying: $viewModel.isPlaying,
                    progress: $viewModel.progress
                )
                HStack(spacing: 4) {
                    Text(viewModel.duration)
                        .font(.reqular(size: 14))
                    if message.isUnread {
                        BlueDot()
                    }
                    Spacer(minLength: 0)
                }
            }
            .foregroundColor(isOutgoing ? .tg_white : .tg_black)
            .lineLimit(1)
        }
        .padding(.vertical, 4)
    }
}

struct VoiceMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        VoiceNoteMessageRow(
            message: VoiceMessage(
                base: .mock(.empty),
                waveform: [20, 30, 40],
                duration: 260,
                url: nil,
                isUnread: true,
                loader: nil
            )
        )
    }
}
