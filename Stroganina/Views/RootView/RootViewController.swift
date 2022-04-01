//
//  RootViewController.swift
//  Stroganina
//
//  Created by Alex Shipin on 01.04.2022.
//

import Foundation
import UIKit
import SwiftUI

final class RootViewController: UIViewController {
    let content = NavigationController()
    var isShowDisconnect: Bool? = nil {
        didSet {
            guard isShowDisconnect != oldValue else {
                return
            }
            UIView.animate(withDuration: 0.3) {
                self.topConstraint.isActive = self.isShowDisconnect ?? false
                self.view.setNeedsLayout()
                self.view.layoutSubviews()
            }
        }
    }

    private let disconectLabel: UILabel = UILabel()

    private lazy var topConstraint: NSLayoutConstraint = {
        disconectLabel.bottomAnchor.constraint(equalTo: content.view.topAnchor)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addLabel()
        addContent()
    }

    private func addLabel() {
        let container = UIView()
        container.backgroundColor = UIColor(Color.tg_red)
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        NSLayoutConstraint.activate([
            container.rightAnchor.constraint(equalTo: view.rightAnchor),
            container.leftAnchor.constraint(equalTo: view.leftAnchor),
            container.topAnchor.constraint(equalTo: view.topAnchor),
        ])

        disconectLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(disconectLabel)
        disconectLabel.textColor = UIColor(Color.tg_white)
        disconectLabel.textAlignment = .center
        disconectLabel.text = "Disconnect"
        disconectLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            disconectLabel.rightAnchor.constraint(equalTo: container.rightAnchor),
            disconectLabel.leftAnchor.constraint(equalTo: container.leftAnchor),
            disconectLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            disconectLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            disconectLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func addContent() {
        view.addSubview(content.view)
        addChild(content)
        content.didMove(toParent: self)

        content.view.translatesAutoresizingMaskIntoConstraints = false

        let top = content.view.topAnchor.constraint(equalTo: view.topAnchor)
        top.priority = .defaultHigh
        top.isActive = true

        NSLayoutConstraint.activate([
            content.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            content.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            content.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension RootViewController: Listener {
    func update(_ notifications: [Notification]) {
        for notification in notifications {
            switch notification {
            case .closeConnect:
                isShowDisconnect = true
            case .reconnected:
                isShowDisconnect = false
            default:
                break
            }
        }
    }
}

final class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.prefersLargeTitles = true
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }

    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
    }
}

import SwiftUI

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
