//
//  Font+Stroganina.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import SwiftUI

extension Font {

    static func medium(size: CGFloat) -> Font {
        system(size: size, weight: .medium, design: .default)
    }

    static func reqular(size: CGFloat) -> Font {
        system(size: size, weight: .regular, design: .default)
    }
}
