//
//  PushService.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 04.11.2021.
//

import Foundation
import NetworkApi
import UIKit

protocol PushServiceProtocol {
    func appendHandler(_ handler: PushNotificationHandler)
    func requestPush()
}

struct PushServiceMock: PushServiceProtocol {
    func appendHandler(_ handler: PushNotificationHandler) {}

    func requestPush() { }
}

final class PushService: NSObject, PushServiceProtocol {
    private let api: Networking
    private let store: Store
    private let updateCenter: UpdateCenter
    private var handlers = [WeakContainer<PushNotificationHandler>]()

    init(api: Networking, store: Store, updateCenter: UpdateCenter) {
        self.api = api
        self.store = store
        self.updateCenter = updateCenter
        super.init()
        self.requestPush()
    }

    func appendHandler(_ handler: PushNotificationHandler) {
        handlers.append(.init(handler))
    }

    func requestPush() {
        UNUserNotificationCenter.current().delegate = self
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

extension PushService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        guard
            let info = self.pushNotificationInfo(notification),
            self.handlers.contains(where: { ($0.value?.canShow(info: info)) ?? false })
        else {
            completionHandler([])
            return
        }
        completionHandler([.banner])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler:@escaping () -> Void
    ) {
        DispatchQueue.main.async {
            guard
                response.actionIdentifier == UNNotificationDefaultActionIdentifier,
                let info = self.pushNotificationInfo(response.notification)
            else {
                return
            }
            DispatchQueue.main.async {
                self.handlers.forEach { container in
                    container.value?.open(info: info)
                }
                completionHandler()
            }
        }
    }

    func pushNotificationInfo(_ notification: UNNotification) -> PushNotificationInfo?  {
        let userInfo = notification.request.content.userInfo
        guard let chatId = userInfo["chatId"] as? Chat.ID else {
            return nil
        }
        return PushNotificationInfo(chatId: chatId)
    }
}

protocol PushNotificationHandler: AnyObject {
    func canShow(info: PushNotificationInfo) -> Bool
    func open(info: PushNotificationInfo)
}

struct PushNotificationInfo {
    let chatId: Chat.ID
}

extension PushService {
    static let updateTokenNotification = NSNotification.Name("updateTokenNotification")
}
