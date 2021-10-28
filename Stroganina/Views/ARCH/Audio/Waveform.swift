//
//  Waveform.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 29.05.2021.
//

import SwiftUI


struct Waveform: View {
    private let heights: [CGFloat]
    private let isOutgoing: Bool
    private let size: CGSize

    @Binding var isPlaying: Bool
    @Binding var progress: CGFloat

    init(
        bytes: [UInt8],
        isOutgoing: Bool,
        isPlaying: Binding<Bool>,
        progress: Binding<CGFloat>
    ) {
        self.size = CGSize(width: bytes.count * 3, height: 17)
        self.isOutgoing = isOutgoing
        self._isPlaying = isPlaying
        self._progress = progress

        let minHeight: CGFloat = 3
        let bytesMax = max(bytes.max() ?? 0, 1)
        let scale = (size.height - minHeight) / CGFloat(bytesMax)
        self.heights = bytes.map {
            minHeight + CGFloat($0) * scale
        }
    }

    private var fillColor: Color {
        isOutgoing ? .tg_white : .tg_blue
    }

    var body: some View {
        ZStack {
            columns(color: fillColor.opacity(0.4))
            columns(color: fillColor)
                .mask(mask)
        }
        .frame(size: size)
        .clipped()
        .padding(.vertical, 2)
    }

    var mask: some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(
                    width: size.width * (isPlaying ? progress : 1),
                    height: size.height
                )
            Spacer(minLength: 0)
        }
        .transition(.opacity)
    }

    func columns(color: Color) -> some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            HStack(alignment: .bottom, spacing: 1) {
                ForEach(heights, id: \.self) {
                    Rectangle()
                        .fill(color)
                        .frame(width: 2, height: $0)
                        .cornerRadius(2)
                }
            }
        }
    }
}

struct Waveform_Previews: PreviewProvider {

    static var previews: some View {
        VStack {
            Waveform(
                bytes: [
                    0, 0, 2, 2, 5, 6, 7, 4, 3, 4,
                    6, 5, 7, 4, 3, 3, 3, 1, 1, 0,
                    0, 5, 8, 8, 5, 5, 3, 0, 0, 0
                ],
                isOutgoing: false,
                isPlaying: .constant(true),
                progress: .constant(1)
            )
        }
        .background(Color.tg_white)
    }
}

