//
//  HostingController.swift
//  Stroganina
//
//  Created by Alex Shipin on 02.04.2022.
//

import SwiftUI
import UIKit

final class HostingController<Screen: IScreenView>: UIHostingController<Screen> {
    private let isNavigationBarHidden: Bool?

    init(_ screen: Screen) {
        self.isNavigationBarHidden = screen.navigationBarConfig.hidden
        super.init(rootView: screen)
    }

    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let isNavigationBarHidden = isNavigationBarHidden {
            self.navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: false)
        }
    }
}
