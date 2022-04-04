//
//  IPadNavigation.swift
//  Stroganina
//
//  Created by Alex Shipin on 02.04.2022.
//

import UIKit

final class IPadNavigation: Navigation {
    let window: UIWindow

    private var navigationController: NavigationController = NavigationController()
    private var isFullScreen: Bool = false
    private let updateCenter: UpdateCenter

    init(window: UIWindow, updateCenter: UpdateCenter) {
        self.window = window
        self.updateCenter = updateCenter
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
            let root = RootViewController<NavigationController>()
            updateCenter.addListener(root)
            navigationController = root.content
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.viewControllers = [vc]
            window.rootViewController = root
        } else {
            isFullScreen = false
            navigationController = NavigationController()
            navigationController.navigationBar.prefersLargeTitles = false
            navigationController.viewControllers = []
            let rootNavigation = NavigationController()
            rootNavigation.viewControllers = [vc]
            rootNavigation.navigationBar.prefersLargeTitles = true
            let root = RootViewController<UISplitViewController>()
            root.content.preferredDisplayMode = .oneBesideSecondary
            updateCenter.addListener(root)
            root.content.viewControllers = [rootNavigation, navigationController]
            window.rootViewController = root
        }
    }
}

