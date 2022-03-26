//
//  UpdateCenter.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import Foundation
import NetworkApi

final class UpdateCenter {

    private let api: Networking
    private var listeners = [WeakContainer]()
    private let queue = DispatchQueue(label: "stroganina.updates", qos: .userInteractive)

    init(api: Networking) {
        self.api = api
    }

    func start() {
        queue.async { [weak self] in
            self?.activate()
        }
    }

    func addListener(_ listener: Listener) {
        self.listeners.append(WeakContainer(listener))
    }

    func sendNotification(_ notifications: Notification...) {
        self.update(notifications)
    }
    
    func activate(_ reconnect: Bool = false) {
        api.addListener(GetUpdate()) { [weak self] result in
            switch result {
            case .success(let response):
                self?.process(notifications: response.notifications)
            case .failure(let error):
                if case ApiError.closeConnect = error {
                    self?.update([.closeConnect])
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self?.activate(true)
                    }
                }
            }
        }
        api.perform(AddListenerUpdate()) { [weak self] result in
            if case .success = result, reconnect {
                self?.update([.reconnected])
            }
        }
    }

    private func update(_ notifications: [Notification]) {
        var newListeners = [WeakContainer]()
        for container in listeners {
            guard let listener = container.value else {
                continue
            }
            newListeners.append(container)
            listener.update(notifications)
        }
        listeners = newListeners
    }

    private func process(notifications: [SafeCodableContainer<GetUpdate.Response.Notification>]){
        var result = [Notification]()
        for notification in notifications {
            switch notification.value {
            case .newMessage(let message):
                result.append(.newMessage(.init(message, identifier: nil)))
            case .newChat(let chat):
                result.append(.newChat(.init(chat)))
            case .none:
                continue
            }
        }
        self.update(result)
    }
}

extension UpdateCenter {
    final class WeakContainer {
        weak var value: Listener?

        init(_ value: Listener) {
            self.value = value
        }
    }
}

protocol Listener: AnyObject {
    func update(_ notifications: [Notification])
}
