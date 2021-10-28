//
//  WKVideoPlayer.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 28.05.2021.
//

import SwiftUI

struct WKVideoPlayer: WKInterfaceObjectRepresentable {

    @Binding var isPlaying: Bool
    @Binding var thumbnail: UIImage?
    let url: URL
    let size: CGSize

    func makeWKInterfaceObject(context: Context) -> WKInterfaceInlineMovie {
        let movie = WKInterfaceInlineMovie()
        movie.setMovieURL(url)
        movie.setWidth(size.width)
        movie.setHeight(size.height)
        return movie
    }

    func updateWKInterfaceObject(_ wkInterfaceObject: WKInterfaceInlineMovie, context: Context) {
        if isPlaying {
            wkInterfaceObject.playFromBeginning()
        } else {
            wkInterfaceObject.pause()
        }
        if let thumbnail = thumbnail {
            wkInterfaceObject.setPosterImage(WKImage(image: thumbnail))
        }
    }
}
