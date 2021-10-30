//
//  Api.swift
//  Stroganina
//
//  Created by Denis Kamkin on 28.10.2021.
//

import Foundation

protocol Networking {
    func perform<F: ApiFunction>(
        _ function: F,
        completion: @escaping (Result<F.Response, ApiError>) -> Void
    )
}

final class Api: NSObject, Networking {

    private lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    private let config: Config
    private let store: Store
    private var authorisationInfo: AuthorisationInfo? { store.authorisationInfo }

    init(
        config: Config,
        store: Store
    ) {
        self.config = config
        self.store = store
    }

    func perform<F: ApiFunction>(
        _ function: F,
        completion: @escaping (Result<F.Response, ApiError>) -> Void
    ) {
        do {
            let requestContainer = createRequest(function)
            let data = try JSONEncoder().encode(requestContainer)
            let url = config.endPoint.appendingPathComponent(F.method)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = data
            session.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(.networkError(error)))
                    }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                    }
                    return
                }
                do {
                    let result = try JSONDecoder().decode(Response<F.Response>.self, from: data)
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print(json)
                    }
                    if let content = result.content {
                        DispatchQueue.main.async {
                            completion(.success(content))
                        }
                        return
                    }
                    if let error = result.error {
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
    
    private func createRequest<F: ApiFunction>(_ function: F) -> Request<F> {
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
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
       completionHandler(.useCredential, urlCredential)
    }
}

extension Api {
    struct Config {
        static let `default` = Config(endPoint: URL(string: "http://127.0.0.1:8080")!)

        let endPoint: URL
    }
}
