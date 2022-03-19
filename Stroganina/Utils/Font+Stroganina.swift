//
//  Font+Stroganina.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import SwiftUI

extension Font {

    static func regular(size: CGFloat) -> Font {
        system(size: size, weight: .regular, design: .default)
    }
    
    static func medium(size: CGFloat) -> Font {
        system(size: size, weight: .medium, design: .default)
    }

    static func bold(size: CGFloat) -> Font {
        system(size: size, weight: .bold, design: .default)
    }
}
