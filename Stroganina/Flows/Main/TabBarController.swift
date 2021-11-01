//
//  MainTabBarController.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 01.11.2021.
//

import UIKit

final class TabBarController: UITabBarController {

    private let hideNavigation: Bool

    init(hideNavigation: Bool) {
        self.hideNavigation = hideNavigation
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(hideNavigation, animated: false)
    }
}
