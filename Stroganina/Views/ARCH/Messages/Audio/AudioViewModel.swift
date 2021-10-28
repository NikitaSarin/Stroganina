//
//  AudioViewModel.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 28.05.2021.
//

import CoreGraphics
import Combine

final class AudioViewModel: ObservableObject {

    @Published var progress: CGFloat = 0
    @Published var isPlaying = false {
        didSet {
            if isPlaying {
                if message.url == nil {
                    message.load()
                } else {
                    player?.play()
                    setupProgressTimer()
                }
            } else {
                player?.pause()
                invalidateProgressTimer()
            }
        }
    }

    private var player: SinkPlayer?
    private let message: PlayableMessage

    let duration: String
    private var urlCancellable: Cancellable?

    private var progressTimer: Timer?

    init(message: PlayableMessage) {
        self.message = message
        self.duration = calculateDuration(from: message.duration)

        urlCancellable = message.$url.sink { [weak self] url in
            guard let url = url else { return }
            self?.setupPlayer(with: url)
        }
    }

    private func setupPlayer(with url: URL) {
        player = SinkPlayer(url: url) { [weak self] in
            self?.isPlaying = false
            self?.invalidateProgressTimer()
        }

        if isPlaying {
            player?.play()
            setupProgressTimer()
        }
    }

    private func setupProgressTimer() {
        if let voice = (message as? VoiceMessage), voice.isUnread {
            voice.messageListenedAction?()
            voice.isUnread = false
        }

        let interval: CGFloat = 1 / 30
        let step: CGFloat = interval / CGFloat(max(message.duration, 1))
        self.progressTimer = Timer.scheduledTimer(
            withTimeInterval: TimeInterval(interval),
            repeats: true
        ) { [weak self] _ in
            let progress = (self?.progress ?? 0) + step
            if progress >= 1 {
                self?.isPlaying = false
            } else {
                self?.progress = max(0, progress)
            }
        }
    }

    private func invalidateProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
        progress = 0
    }

    private func set(seconds: TimeInterval) {
        progress = CGFloat(seconds) / max(CGFloat(message.duration), 1)
    }
}
