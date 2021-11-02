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
        completion: @escaping (Result<F.Response, ApiError>) -> Void
    )
}

public final class Api: NSObject, Networking {

    private lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
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

    public func perform<F: ApiFunction>(
        _ function: F,
        completion: @escaping (Result<F.Response, ApiError>) -> Void
    ) {
        do {
            let requestContainer = makeRequest(function)
            let data = try JSONEncoder().encode(requestContainer)
            let url = config.endPoint.appendingPathComponent(F.method)
            var request = URLRequest(url: url)
            if F.longTimeOut {
                request.timeoutInterval = 60
            }
            request.httpMethod = "POST"
            request.httpBody = data
            log("[API][\(F.method)][REQUEST]", String(data: data, encoding: .utf8) ?? "")
            session.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        log("[API][\(F.method)][ERROR]", "\(error)")
                        completion(.failure(.networkError(error)))
                    }
                    return
                }
                guard let data = data else {
                    log("[API][\(F.method)][ERROR]", "data is empty")
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                    }
                    return
                }
                do {
                    log("[API][\(F.method)][RESPONSE]", String(data: data, encoding: .utf8) ?? "")
                    let result = try JSONDecoder().decode(Response<F.Response>.self, from: data)
                    if let content = result.content {
                        DispatchQueue.main.async {
                            completion(.success(content))
                        }
                        return
                    }
                    if let error = result.errors?.first {
                        DispatchQueue.main.async {
                            completion(.failure(.userError(error)))
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        completion(.failure(.networkError(error)))
                    }
                }
            }.resume()
        } catch {
            DispatchQueue.main.async {
                completion(.failure(.networkError(error)))
            }
        }
    }

    private func makeRequest<F: ApiFunction>(_ function: F) -> Request<F> {
        let time = Date.serverTime
        let request = Request(
            time: time,
            authorisation: authorisationInfo.flatMap {
                AuthorisationInfo(
                    token: $0.token,
                    secretKey: $0.secretKey.hash(with: time)
                )
            },
            content: function
        )
        return request
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
            certificates: [try! Data(contentsOf: Bundle.main.url(forResource: "cert", withExtension: "crt")!)],
            withoutCertificateVerification: false
        )
        
        public static let local = Config(
            endPoint: URL(string: "http://127.0.0.1:8080")!,
            certificates: [],
            withoutCertificateVerification: true
        )

        let endPoint: URL
        let certificates: [Data]
        
        // отключает проверку сертификата нужно для дебага
        let withoutCertificateVerification: Bool
    }
}
