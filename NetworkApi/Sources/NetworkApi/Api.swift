//
//  Api.swift
//  Stroganina
//
//  Created by Denis Kamkin on 28.10.2021.
//

import Foundation

public protocol Networking {
    func perform<F: ApiFunction>(
        _ function: F,
        queue: DispatchQueue,
        completion: @escaping (Result<F.Response, ApiError>) -> Void
    )

    func addListener<L: ApiListener>(
        _ listener: L,
        queue: DispatchQueue,
        completion: @escaping (Result<L.Response, ApiError>) -> Void
    )
}

public extension Networking {
    func addListener<L: ApiListener>(
        _ listener: L,
        completion: @escaping (Result<L.Response, ApiError>) -> Void
    ) {
        addListener(listener, queue: .main, completion: completion)
    }

    func perform<F: ApiFunction>(
        _ function: F,
        completion: @escaping (Result<F.Response, ApiError>) -> Void
    ) {
        perform(function, queue: .main, completion: completion)
    }
}

public final class Api: NSObject, Networking {

    private lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    private lazy var webSocketManager = WebSocketManager(session: session, url: config.wsEndPoint)
    private let config: Config
    private let store: ApiStore
    private var authorisationInfo: AuthorisationInfo? { store.authorisationInfo }

	public init(
        config: Config,
        store: ApiStore
    ) {
        self.config = config
        self.store = store
    }

    public func addListener<L: ApiListener>(
        _ listener: L,
        queue: DispatchQueue,
        completion: @escaping (Result<L.Response, ApiError>) -> Void
    ) {
        let handler = DefaultResponseHandler(
            reuestId: nil,
            method: L.method,
            queue: queue,
            handler: completion
        )
        webSocketManager.registerHandler(handler)
    }

    public func perform<F: ApiFunction>(
        _ function: F,
        queue: DispatchQueue,
        completion: @escaping (Result<F.Response, ApiError>) -> Void
    ) {
        do {
            let reuestId = UUID().uuidString
            let data = try makeData(function, reuestId: reuestId)
            let handler = DefaultResponseHandler(
                reuestId: reuestId,
                method: F.method,
                queue: queue,
                handler: completion
            )
            switch F.wayType {
            case .http:
                let request = makeRequest(function, data: data)
                session.dataTask(with: request) { (data, _, error) in
                    handler.handler(data: data, error: error)
                }.resume()
            case .ws:
                webSocketManager.sendData(data, handler: handler)
            }
        } catch {
            queue.async {
                completion(.failure(.networkError(error)))
            }
        }
    }

    private func makeRequest<F: ApiFunction>(_ function: F, data: Data) -> URLRequest {
        let url = config.endPoint.appendingPathComponent(F.method)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        log("[API][\(F.method)][REQUEST]", String(data: data, encoding: .utf8) ?? "")
        return request
    }

    private func makeData<F: ApiFunction>(_ function: F, reuestId: String) throws -> Data {
        let time = Date.serverTime
        let request = Request(
            time: time,
            method: F.method,
            reuestId: reuestId,
            authorisation: authorisationInfo.flatMap {
                AuthorisationInfo(
                    token: $0.token,
                    secretKey: $0.secretKey.hash(with: time)
                )
            },
            content: function
        )
        return try JSONEncoder().encode(request)
    }
}

extension Api: URLSessionDelegate {
    public func urlSession(
        _ session: URLSession, 
        didReceive challenge: URLAuthenticationChallenge, 
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        if config.withoutCertificateVerification {
            let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, urlCredential)
            return
        }
        let serverCredential = getServerUrlCredential(protectionSpace: challenge.protectionSpace)
        guard serverCredential != nil else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        completionHandler(.useCredential, serverCredential)
    }
}

extension Api {
    func getServerUrlCredential(protectionSpace: URLProtectionSpace) -> URLCredential? {
        if let serverTrust = protectionSpace.serverTrust {
            /// Надо будет другой сертификат подложить
            //var error: CFError? = nil
            //let status = SecTrustEvaluateWithError(serverTrust, &error)

            if
                true,
                let serverCertificate = SecTrustGetCertificateAtIndex(
                    serverTrust,
                    SecTrustGetCertificateCount(serverTrust) - 1
                )
            {
                let serverCertificateData = SecCertificateCopyData(serverCertificate)

                guard config.certificates.contains(where: { $0 == serverCertificateData as Data }) else {
                    print("Certificates doesn't match.")
                    return nil
                }

                return URLCredential(trust: serverTrust)
            }
        }
        return nil
    }
}

extension Api {
    public struct Config {
        public static let `default` = Config(
            endPoint: URL(string: "https://176.57.214.20:8443")!,
            wsEndPoint: URL(string: "wss://176.57.214.20:8443")!,
            certificates: [try! Data(contentsOf: Bundle.main.url(forResource: "cert", withExtension: "crt")!)],
            withoutCertificateVerification: false
        )

        public static let local = Config(
            endPoint: URL(string: "http://127.0.0.1:8080")!,
            wsEndPoint: URL(string: "ws://127.0.0.1:8080")!,
            certificates: [],
            withoutCertificateVerification: true
        )

        let endPoint: URL
        let wsEndPoint: URL
        let certificates: [Data]

        // отключает проверку сертификата нужно для дебага
        let withoutCertificateVerification: Bool
    }
}
