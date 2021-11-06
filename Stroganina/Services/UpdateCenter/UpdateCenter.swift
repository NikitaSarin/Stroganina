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
    
    func activate() {
        api.addListener(GetUpdate()) { [weak self] result in
            switch result {
            case .success(let response):
                self?.process(notifications: response.notifications)
            case .failure(let error):
                if case ApiError.closeConnect = error {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self?.activate()
                    }
                }
            }
        }
        api.perform(AddListenerUpdate()) { _ in
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

    private func process(notifications: [GetUpdate.Response.Notification]){
        var result = [Notification]()
        for notification in notifications {
            switch notification {
            case .newMessage(let message):
                result.append(.newMessage(MessageWrapper(message)))
            case .addedInNewChat(let chat):
                result.append(.newChat(Chat(chat)))
            case .unknown:
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
