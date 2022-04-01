//
//  MainTabBarController.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 01.11.2021.
//

import UIKit

final class TabBarController: UITabBarController, TabNavigation {

    override var navigationItem: UINavigationItem {
        (self.viewControllers?.count ?? 0 > 0) ? self.viewControllers![0].navigationItem : super.navigationItem
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func add<Screen: IScreenView>(_ item: TabItem<Screen>) {
        let host = HostingController(item.screen)
        host.tabBarItem = .init(title: item.title, image: UIImage(systemName: item.image), tag: self.viewControllers?.count ?? 0)
        self.setViewControllers((self.viewControllers ?? []) + [host], animated: false)
    }
}
