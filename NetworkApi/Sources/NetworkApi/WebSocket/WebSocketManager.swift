//
//  File.swift
//  
//
//  Created by Aleksandr Shipin on 05.11.2021.
//

import Foundation

final class WebSocketManager {
    @Locked private var handlers: [ResponseHandlerIdentifier: ResponseHandler] = [:]
    private let connect: WebSocketConnect

    init(session: URLSession, url: URL) {
        connect = WebSocketConnect(session: session, url: url)
        connect.delegate = self
    }

    func reconnect() {
        connect.reconnect()
    }

    func registerHandler(_ handler: ResponseHandler) {
        handlers[handler.identifeir] = handler
    }

    func sendData(_ data: Data, handler: ResponseHandler) {
        registerHandler(handler)
        connect.send(data) { [weak self] error in
            guard let error = error else {
                return
            }
            DispatchQueue.main.async {
                handler.handler(data: nil, error: error)
            }
            self?.removeHandler(handler)
        }
    }

    func removeHandler(_ handler: ResponseHandler) {
        handlers[handler.identifeir] = nil
    }
}

extension WebSocketManager: WebSocketConnectDelegate {
    func didClose(error: ApiError) {
        var handlers: [ResponseHandlerIdentifier: ResponseHandler] = [:]
        self.$handlers.mutate {
            handlers = $0
            $0 = [:]
        }
        DispatchQueue.main.async {
            for handler in handlers {
                handler.value.handler(data: nil, error: error)
            }
        }
    }

    func didLoad(_ data: Data) {
        log("[API][WS][RESPONSE]", String(data: data, encoding: .utf8) ?? "")
        guard let metaInfo = try? JSONDecoder().decode(ResponseMetaInfo.self, from: data) else {
            log("[API][WS][ERROR]", "не получилось извлечь мета инфо")
            return
        }
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
        DispatchQueue.main.async {
            handler.handler(data: data, error: nil)
        }
        if case .request = identifier {
            self.removeHandler(handler)
        }
    }
}
