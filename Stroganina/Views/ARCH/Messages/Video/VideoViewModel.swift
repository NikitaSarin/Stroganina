//
//  VideoViewModel.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 28.05.2021.
//

import Combine
import UIKit

final class VideoViewModel: ObservableObject {

    @Published var progress: CGFloat = 0
    @Published var message: VideoMessage
    @Published var thumbnail: UIImage?
    @Published var isPlaying = false {
        didSet {
            if isPlaying {
                if message.url == nil {
                    message.load()
                } else {
                    play()
                }
            } else {
                pause()
            }
        }
    }

    let videoSize: CGSize
    let duration: String

    private var stopTimer: Timer?
    private var progressTimer: Timer?

    private var thumbnailCancellable: Cancellable?
    private var urlCancellable: Cancellable?

    init(message: VideoMessage) {
        self.message = message
        self.duration = calculateDuration(from: message.duration)
        self.videoSize = prefferedContentSize(
            for: message.size,
            maxHeight: safeScreenHeight
        )

        thumbnailCancellable = message.$thumbnail.sink { [weak self] in
            self?.thumbnail = $0
        }
        urlCancellable = message.$url.sink { [weak self] _ in
            guard self?.isPlaying == true else { return }
            self?.play()
        }
    }

    private func play() {
        AudioContentSink.pauseContentBlock?()
        AudioContentSink.pauseContentBlock = { [weak self] in
            self?.isPlaying = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setupProgressTimer()
            self.stopTimer = Timer.scheduledTimer(
                withTimeInterval: TimeInterval(self.message.duration),
                repeats: false
            ) { [weak self] _ in
                self?.isPlaying = false
            }
        }
    }

    private func pause() {
        AudioContentSink.pauseContentBlock = nil
        stopTimer?.invalidate()
        stopTimer = nil

        progressTimer?.invalidate()
        progressTimer = nil
        progress = 0
    }


    private func setupProgressTimer() {
        let interval: CGFloat = 1 / 30
        let step: CGFloat = interval / CGFloat(max(message.duration, 1))
        self.progressTimer = Timer.scheduledTimer(
            withTimeInterval: TimeInterval(interval),
            repeats: true
        ) { [weak self] _ in
            let progress = (self?.progress ?? 0) + step
            self?.progress = max(0, min(1, progress))
        }
    }
}
