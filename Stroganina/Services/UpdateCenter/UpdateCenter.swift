//
//  UpdateCenter.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import Foundation

final class UpdateCenter {
    private let api: Networking

    private var listeners = [WeakContainer]()

    init(api: Networking) {
        self.api = api
        updateLoop()
    }
    
    func addListener(_ listener: Listener) {
        self.listeners.append(WeakContainer(listener))
    }
    
    func sendNotification(_ notifications: [Notification]) {
        self.update(notifications)
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
    
    private func updateLoop() {
        api.perform(GetUpdate()) { [weak self] result in
            switch result {
            case .success(let response):
                self?.didLoadUpdate(response.notifications)
                self?.updateLoop()
            case .failure(_):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                    self?.updateLoop()
                }
                break
            }
        }
    }
    
    private func didLoadUpdate(_ notifications: [GetUpdate.Response.Notification]){
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
