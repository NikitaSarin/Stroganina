//
//  File.swift
//  
//
//  Created by Aleksandr Shipin on 05.11.2021.
//

import Foundation

final class WebSocketManager {
    private let session: URLSession
    private let url: URL

    private var handlers: [ResponseHandlerIdentifier: ResponseHandler] = [:]
    private var socketTask: URLSessionWebSocketTask?

    init(session: URLSession, url: URL) {
        self.session = session
        self.url = url
    }

    func registerHandler(_ handler: ResponseHandler) {
        handlers[handler.identifeir] = handler
    }

    func sendData(_ data: Data, handler: ResponseHandler) {
        if socketTask == nil {
            active()
        }
        self.registerHandler(handler)
        socketTask?.send(.data(data), completionHandler: { error in
            guard let error = error else {
                return
            }
            handler.handler(data: nil, error: error)
            DispatchQueue.main.async {
                self.removeHandler(handler)
            }
        })
    }

    func removeHandler(_ handler: ResponseHandler) {
        handlers[handler.identifeir] = nil
    }

    private func active() {
        if (socketTask?.closeReason) != nil {
            let error = ApiError.closeConnect
            for handler in handlers {
                handler.value.handler(data: nil, error: error)
            }
            handlers = [:]
            socketTask = nil
            return
        }
        if socketTask == nil {
            socketTask = session.webSocketTask(with: url)
        }
        socketTask?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                self?.didLoad(message: message)
            case .failure(let error):
                log("[API][WS][ERROR]", "\(error)")
                break
            }
            self?.active()
        })
        socketTask?.resume()
    }

    private func didLoad(message: URLSessionWebSocketTask.Message) {
        switch message {
        case .data(let data):
            self.didLoad(data)
        case .string(let string):
            guard let data = string.data(using: .utf8) else {
                log("[API][WS][ERROR]", "чет мля стринг пришел \(string)")
                return
            }
            self.didLoad(data)
        @unknown default:
            log("[API][WS][ERROR]", "хуетень на месте")
        }
    }

    private func didLoad(_ data: Data) {
        log("[API][WS][RESPONSE]", String(data: data, encoding: .utf8) ?? "")
        guard let metaInfo = try? JSONDecoder().decode(ResponseMetaInfo.self, from: data) else {
            log("[API][WS][ERROR]", "не получилось извлечь мета инфо")
            return
        }
        DispatchQueue.main.async {
            let identifier: ResponseHandlerIdentifier
            if let reuestId = metaInfo.requestId {
                identifier = .request(reuestId: reuestId)
            } else {
                identifier = .listener(method: metaInfo.method)
            }
            guard let handler = self.handlers[identifier] else {
                log("[API][WS][ERROR]", "handler not found \(identifier)")
                return
            }
            handler.handler(data: data, error: nil)
            if case .request = identifier {
                self.removeHandler(handler)
            }
        }
    }
}
