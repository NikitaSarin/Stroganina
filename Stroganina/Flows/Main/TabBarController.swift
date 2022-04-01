//
//  MainTabBarController.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 01.11.2021.
//

import UIKit

final class TabBarController: UITabBarController {

    override var navigationItem: UINavigationItem {
        self.viewControllers![0].navigationItem
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

}
