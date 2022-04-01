//
//  IOSNavigation.swift
//  Stroganina
//
//  Created by Alex Shipin on 01.04.2022.
//

import UIKit

final class IOSNavigation: Navigation {
    let navigationController: UINavigationController = UINavigationController()

    init() {
        navigationController.navigationBar.prefersLargeTitles = true
    }

    func setRoot(animated: Bool, requredFullScreen: Bool, setting: (TabNavigation) -> Void) {
        let tabBar = TabBarController()
        setting(tabBar)
        navigationController.setViewControllers([tabBar], animated: animated)
    }

    func setRoot<Screen: IScreenView>(_ screen: Screen, animated: Bool, requredFullScreen: Bool) {
        let vc = HostingController(screen)
        navigationController.setViewControllers([vc], animated: animated)
    }

    func pushViewController<Screen: IScreenView>(_ screen: Screen, animated: Bool) {
        let vc = HostingController(screen)
        navigationController.pushViewController(vc, animated: animated)
    }

    func popup(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    func present<Screen: IScreenView>(_ screen: Screen, animated: Bool, completion: (() -> Void)?) {
        let vc = HostingController(screen)
        navigationController.present(vc, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }

    func present(animated: Bool, completion: (() -> Void)?, _ setting: ((Navigation) -> Void)) {
        let navigation = IOSNavigation()
        setting(navigation)
        navigationController.present(navigation.navigationController, animated: animated, completion: completion)
    }
}
