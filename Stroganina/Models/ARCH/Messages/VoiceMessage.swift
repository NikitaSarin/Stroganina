//
//  VoiceMessage.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 29.05.2021.
//

final class VoiceMessage: PlayableMessage {

    let waveform: [UInt8]
    @Published var isUnread: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    var messageListenedAction: VoidClosure?

    init(
        base: BaseMessage,
        waveform: [UInt8],
        duration: Int,
        url: URL?,
        isUnread: Bool,
        loader: SingleFileLoader?
    ) {
        self.waveform = waveform
        self.isUnread = isUnread
        super.init(
            base: base,
            duration: duration,
            url: url,
            loader: loader
        )
    }
}
