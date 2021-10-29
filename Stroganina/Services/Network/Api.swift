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
    private var token: String? { store.token }

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
            let requestContainer = Request(token: token, content: function)
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
        static let `default` = Config(endPoint: URL(string: "https://176.57.214.20:8443")!)

        let endPoint: URL
    }
}
