//
//  PlayButton.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 28.05.2021.
//

import SwiftUI

struct PlayButton: View {

    @Binding var isPlaying: Bool
    let isOutgoing: Bool

    var body: some View {
        Button(action: {
            withAnimation {
                isPlaying.toggle()
            }
        }, label: {
            Group {
                if isPlaying {
                    Image("pause")
                        .resizable()
                        .padding(5)
                } else {
                    Image("play")
                        .resizable()
                        .padding(4)
                        .padding(.leading, 3)
                }
            }
            .foregroundColor(color(contrast: !isOutgoing))
            .aspectRatio(contentMode: .fit)
            .transition(.scale)
            .animation(.spring())
        })
        .background(color(contrast: isOutgoing))
        .transition(.opacity)
        .frame(side: 42)
        .cornerRadius(21)
    }

    private func color(contrast: Bool) -> Color {
        contrast ? .tg_white : .tg_blue
    }
}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PlayButton(isPlaying: .constant(false), isOutgoing: true)
            PlayButton(isPlaying: .constant(true), isOutgoing: false)
        }
    }
}
