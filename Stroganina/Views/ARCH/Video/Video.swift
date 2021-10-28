//
//  Video.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 28.05.2021.
//

import SwiftUI

extension View {
    func onTap(if condition: Bool, perform: @escaping VoidClosure) -> some View {
        Group {
            if condition {
                self.onTapGesture(perform: perform)
            } else {
                self
            }
        }
    }
}

struct Video: View {

    @Binding var url: URL?
    @Binding var thumbnail: UIImage?
    @Binding var isPlaying: Bool

    let size: CGSize

    var body: some View {
        ZStack {
            if isPlaying {
                if let url = url {
                    WKVideoPlayer(
                        isPlaying: $isPlaying,
                        thumbnail: $thumbnail,
                        url: url,
                        size: size
                    )
                } else {
                    LoadingView()
                }
            } else {
                if let thumb = thumbnail {
                    Image(uiImage: thumb)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                Button(action: {
                    isPlaying = true
                }) {
                    Image("play")
                        .resizable()
                        .frame(width: 14, height: 18)
                        .padding(.leading, 5)
                }
                .frame(side: 42)
                .background(Color.tg_white25)
                .cornerRadius(21)
            }
        }
        .background(Color.tg_greyPlatter)
        .clipped()
        .onTap(if: isPlaying) {
            isPlaying = false
        }
    }
}

struct Video_Previews: PreviewProvider {
    static var previews: some View {
        Video(
            url: .constant(nil),
            thumbnail: .constant(.mops),
            isPlaying: .constant(false),
            size: CGSize(width: 200, height: 100)
        )
    }
}
