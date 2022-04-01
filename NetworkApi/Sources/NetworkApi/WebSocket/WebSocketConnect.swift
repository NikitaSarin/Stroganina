//
//  WebSocketConnect.swift
//  
//
//  Created by Alex Shipin on 01.04.2022.
//

import Foundation

protocol WebSocketConnectDelegate: AnyObject {
    func didLoad(_ data: Data)
    func didClose()
}

final class WebSocketConnect {
    weak var delegate: WebSocketConnectDelegate?

    private static let pingLoopTime: TimeInterval = 5
    private static let pingTimeout: TimeInterval = 10

    private let session: URLSession
    private let url: URL

    @Locked private var socketTask: URLSessionWebSocketTask?
    @Locked private var pingTimer: Timer?
    @Locked private var timeoutTimer: Timer?

    init(session: URLSession, url: URL) {
        self.session = session
        self.url = url
    }

    func send(_ data: Data, completionHandler: @escaping (Error?) -> Void) {
        activeIfNeeded()
        socketTask?.send(.data(data), completionHandler: { error in
            completionHandler(error)
        })
    }

    func close() {
        didDisactive()
    }

    private func activeIfNeeded() {
        guard socketTask == nil else {
            return
        }
        socketTask = session.webSocketTask(with: url)
        ping()
        loop()
    }

    private func loop() {
        socketTask?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                self?.didLoad(message: message)
                self?.loop()
            case .failure:
                return
            }
        })
        socketTask?.resume()
    }

    private func didLoad(message: URLSessionWebSocketTask.Message) {
        switch message {
        case .data(let data):
            delegate?.didLoad(data)
        case .string(let string):
            guard let data = string.data(using: .utf8) else {
                log("[API][WS][ERROR]", "чет мля стринг пришел \(string)")
                return
            }
            delegate?.didLoad(data)
        @unknown default:
            log("[API][WS][ERROR]", "хуетень на месте")
        }
    }

    private func ping() {
        DispatchQueue.main.async { [weak self, socketTask] in
            self?.pingTimer = Timer.scheduledTimer(withTimeInterval: Self.pingLoopTime, repeats: false) { timer in
                self?.socketTask?.sendPing(pongReceiveHandler: { error in
                    guard self?.pingTimer === timer, socketTask === self?.socketTask else {
                        return
                    }
                    if let error = error {
                        log("[API][WS][ERROR]", "ping \(error)")
                        self?.didDisactive()
                    } else {
                        self?.ping()
                    }
                    self?.pingTimer = nil
                })
                self?.timeoutTimer = Timer.scheduledTimer(withTimeInterval: Self.pingTimeout, repeats: false) { _ in
                    guard self?.pingTimer === timer, socketTask === self?.socketTask else {
                        return
                    }
                    self?.didDisactive()
                }
            }
        }
    }

    private func didDisactive() {
        socketTask = nil
        delegate?.didClose()
    }
}

