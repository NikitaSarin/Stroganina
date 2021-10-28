//
//  AnimatedCircle.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 06.06.2021.
//

import SwiftUI

struct AnimatedCircle: View {

    @Binding var progress: CGFloat
    private let strokeStyle = StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)

    var body: some View {
        ZStack {
            Circle()
                .stroke(style: strokeStyle)
                .fill(Color.tg_white25)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(style: strokeStyle)
                .fill(Color.tg_white)
                .rotationEffect(.init(radians: -.pi/2))
        }
    }
}

struct AnimatedCircle_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedCircle(progress: .constant(0.2))
            .padding()
    }
}
