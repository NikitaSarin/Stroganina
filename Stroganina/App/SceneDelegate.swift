//
//  SceneDelegate.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import UIKit
import SwiftUI
import NetworkApi

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var router: Router?
    private var api: Networking?
    private var isFirst: Bool = true

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        AppContext.shared = AppContext(window: window)

        let store = Store()
        store.load()
        let builder = Builder(store: store)
        self.api = builder.api
        if UIDevice.current.userInterfaceIdiom == .pad {
            let navigation = IPadNavigation(window: window, updateCenter: builder.updateCenter)
            router = Router(navigation: navigation, builder: builder)
        } else {
            let navigation = IOSNavigation()
            window.rootViewController = navigation.root
            builder.updateCenter.addListener(navigation.root)
            router = Router(navigation: navigation, builder: builder)
        }
        router?.start()
        window.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        router?.appDidEnterBackground()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        api?.reconnect()
    }
}
