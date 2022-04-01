//
//  IPadNavigation.swift
//  Stroganina
//
//  Created by Alex Shipin on 02.04.2022.
//

import UIKit

final class IPadNavigation: Navigation {
    let window: UIWindow
    let splitViewController = UISplitViewController()
    var navigationController: UINavigationController = UINavigationController()

    private var isFullScreen: Bool = false

    init(window: UIWindow) {
        self.window = window
    }

    func setRoot(animated: Bool, requredFullScreen: Bool, setting: (TabNavigation) -> Void) {
        let tabBar = TabBarController()
        setting(tabBar)
        self.setRoot(vc: tabBar, animated: animated, requredFullScreen: requredFullScreen)
    }

    func setRoot<Screen: IScreenView>(_ screen: Screen, animated: Bool, requredFullScreen: Bool) {
        let vc = HostingController(screen)
        self.setRoot(vc: vc, animated: animated, requredFullScreen: requredFullScreen)
    }

    func pushViewController<Screen: IScreenView>(_ screen: Screen, animated: Bool) {
        let vc = HostingController(screen)
        if isFullScreen {
            navigationController.pushViewController(vc, animated: true)
        } else {
            navigationController.setViewControllers([vc], animated: animated)
        }
    }

    func popup(animated: Bool) {
        if isFullScreen {
            navigationController.popViewController(animated: animated)
        } else {
            navigationController.setViewControllers([], animated: animated)
        }
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

extension IPadNavigation {
    func setRoot(vc: UIViewController, animated: Bool, requredFullScreen: Bool) {
        if requredFullScreen {
            isFullScreen = true
            navigationController = UINavigationController()
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.viewControllers = [vc]
            window.rootViewController = navigationController
        } else {
            isFullScreen = false
            navigationController = UINavigationController()
            navigationController.navigationBar.prefersLargeTitles = false
            navigationController.viewControllers = []
            let rootNavigation = UINavigationController()
            rootNavigation.viewControllers = [vc]
            rootNavigation.navigationBar.prefersLargeTitles = true
            splitViewController.viewControllers = [rootNavigation, navigationController]
            window.rootViewController = splitViewController
        }
    }
}

