//
//  PushService.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 04.11.2021.
//

import NetworkApi
import UIKit

protocol PushServiceProtocol {
    func requestPush()
}

struct PushServiceMock: PushServiceProtocol {
    func requestPush() { }
}

final class PushService: PushServiceProtocol {
    private let api: Networking
    private let store: Store

    init(api: Networking, store: Store) {
        self.api = api
        self.store = store
        self.requestPush()
    }

    func requestPush() {
        guard store.authorisationInfo != nil else {
            return
        }
        NotificationCenter.default.addObserver(
            forName: PushService.updateTokenNotification,
            object: nil,
            queue: nil,
            using: { notification in
                guard let data = notification.object as? Data else {
                    return
                }
                self.setRemoteToken(data)
            })
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
          (granted, error) in
            DispatchQueue.main.async {
                UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                  guard settings.authorizationStatus == .authorized else { return }
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
    }

    func setRemoteToken(_ deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
          return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        api.perform(SetApnsToken(token: token), completion: { _ in })
    }
}

extension PushService {
    static let updateTokenNotification = NSNotification.Name("updateTokenNotification")
}
