//
//  View+Stroganina.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import SwiftUI

extension View {
    func frame(size: CGSize) -> some View {
        frame(width: size.width, height: size.height)
    }

    func frame(edge: CGFloat) -> some View {
        frame(width: edge, height: edge)
    }

    func flip() -> some View {
        return self
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}
