//
//  NavigationController.swift
//  Stroganina
//
//  Created by Alex Shipin on 02.04.2022.
//

import UIKit

final class NavigationController: UINavigationController, UINavigationControllerDelegate {
    override var viewControllers: [UIViewController] {
        didSet {
            if viewControllers.count == 1 {
                print("[TEST]end")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }

    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
    }

    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        print("[TEST]\(viewController)")
    }
}
