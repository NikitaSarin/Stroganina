//
//  RootViewController.swift
//  Stroganina
//
//  Created by Alex Shipin on 01.04.2022.
//

import Foundation
import UIKit
import SwiftUI

final class RootViewController<Content: UIViewController>: UIViewController {
    let content = Content()
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
