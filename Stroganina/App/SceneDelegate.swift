//
//  SceneDelegate.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var router: Router?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        AppContext.shared = AppContext(window: window)

        let store = Store()
        store.load()
        let builder = Builder(store: store)
        if UIDevice.current.userInterfaceIdiom == .pad {
            let navigation = IPadNavigation(window: window)
            router = Router(navigation: navigation, builder: builder)
        } else {
            let navigation = IOSNavigation()
            window.rootViewController = navigation.navigationController
            router = Router(navigation: navigation, builder: builder)
        }
        router?.start()
        window.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        router?.appDidEnterBackground()
    }
}
