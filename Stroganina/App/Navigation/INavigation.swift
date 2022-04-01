//
//  INavigation.swift
//  Stroganina
//
//  Created by Alex Shipin on 01.04.2022.
//

import SwiftUI

struct TabItem<Screen: IScreenView> {
    let title: String
    let image: String
    let screen: Screen
}

protocol TabNavigation {
    func add<Screen: IScreenView>(_ item: TabItem<Screen>)
}

protocol Navigation: AnyObject {
    func setRoot(animated: Bool, requredFullScreen: Bool, setting: (TabNavigation) -> Void)
    func setRoot<Screen: IScreenView>(_ screen: Screen, animated: Bool, requredFullScreen: Bool)

    func pushViewController<Screen: IScreenView>(_ screen: Screen, animated: Bool)
    func popup(animated: Bool)

    func present<Screen: IScreenView>(_ screen: Screen, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)

    func present(animated: Bool, completion: (() -> Void)?, _ setting: ((Navigation) -> Void))
}


struct NavigationBarConfig {
    let hidden: Bool
}

protocol IScreenView: View {
    var navigationBarConfig: NavigationBarConfig { get }
}

extension IScreenView {
    var navigationBarConfig: NavigationBarConfig {
        .init(hidden: false)
    }
}

struct ScreenView<Content: View>: IScreenView {
    let content: Content
    let navigationBarConfig: NavigationBarConfig

    init(_ content: Content, navigationBarConfig: NavigationBarConfig = .init(hidden: false)) {
        self.navigationBarConfig = navigationBarConfig
        self.content = content
    }

    var body: some View {
        content
    }
}
