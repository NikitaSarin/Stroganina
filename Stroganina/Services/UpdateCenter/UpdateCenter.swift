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
    private var listeners = [WeakContainer<Listener>]()
    private let queue = DispatchQueue(label: "stroganina.updates", qos: .userInteractive)
    private let store: Store

    init(api: Networking, store: Store) {
        self.api = api
        self.store = store
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
        guard store.authorisationInfo != nil else {
            return
        }
        api.addListener(GetUpdate()) { [weak self] result in
            switch result {
            case .success(let response):
                self?.process(notifications: response.notifications)
            case .failure(let error):
                if case ApiError.closeConnect = error {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self?.activate(true)
                    }
                }
                if case ApiError.reconnect = error {
                    DispatchQueue.main.async {
                        self?.activate(true)
                    }
                }
            }
        }
        api.perform(AddListenerUpdate()) { [weak self] result in
            if case .success = result {
                self?.update([.reconnected])
            } else {
                if case .failure(let error) = result, case ApiError.reconnect = error {
                    return
                }
                self?.update([.closeConnect])
            }
        }
    }

    private func update(_ notifications: [Notification]) {
        var newListeners = [WeakContainer<Listener>]()
        log("[UpdateCenter][update]", "\(notifications)")
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

final class WeakContainer<ObjectType> {
    var value: ObjectType? {
        return object as? ObjectType
    }

    private var object: AnyObject

    init(_ value: ObjectType) {
        self.object = value as AnyObject
    }
}

protocol Listener: AnyObject {
    func update(_ notifications: [Notification])
}
