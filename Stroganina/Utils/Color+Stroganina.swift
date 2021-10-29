//
//  Color+Stroganina.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import SwiftUI

extension Color {

    static let sgn_brand = Color("Brand")
    static let sgn_primary = Color("Primary")
    static let sgn_background = Color("Background")
    static let sgn_surface = Color("Surface")

    // Legacy

    static let tg_hidden = Color(UIColor(hex: "2094FA00"))

    static let tg_black = Color(UIColor(hex: "000000"))
    static let tg_grey = Color(UIColor(hex: "8E8E93"))
    static let tg_greyPlatter = Color(UIColor(hex: "222223"))

    static let tg_white =  Color(UIColor(white: 1, alpha: 1))
    static let tg_white25 = Color(UIColor(white: 1, alpha: 0.25))
    static let tg_white70 = Color(UIColor(white: 1, alpha: 0.70))

    static let tg_green = Color(UIColor(hex: "34C759"))
    static let tg_orange = Color(UIColor(hex: "FE9400"))
    static let tg_red = Color(UIColor(hex: "FE3C30"))
    static let tg_purple = Color(UIColor(hex: "7878FF"))
}
