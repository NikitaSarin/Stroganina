//
//  AnimatedLine.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 06.06.2021.
//

import SwiftUI

struct AnimatedLine: View {

    @Binding var progress: CGFloat

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Rectangle()
                    .fill(Color.tg_white25)
                    .frame(width: proxy.size.width)
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.tg_white)
                        .frame(width: progress * proxy.size.width)
                    Spacer(minLength: 0)
                }
            }
        }
        .cornerRadius(2)
        .frame(height: 4)
    }
}

struct AnimatedLine_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedLine(progress: .constant(0.2))
            .padding()
    }
}
