//
//  AppContext.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 02.11.2021.
//

import UIKit
import SwiftUI

struct AppContext {
    static var shared: AppContext!
    let window: UIWindow
}

var safeAreaInsets: EdgeInsets {
    let insets = AppContext.shared.window.safeAreaInsets
    return EdgeInsets(
        top: insets.top,
        leading: insets.left,
        bottom: insets.bottom,
        trailing: insets.right
    )
}
