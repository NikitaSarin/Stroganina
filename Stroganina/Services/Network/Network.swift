//
//  Network.swift
//  StroganinaNetwork
//
//  Created by Denis Kamkin on 28.10.2021.
//

import Foundation

protocol Networking {
    func send<RequestType: IRequest>(
        _ request: RequestType,
        parameters: RequestType.RequestParameters,
        completion: @escaping (Result<RequestType.ResponseContent, NetworkServiceError>) -> Void
    )
}

final class Network: Networking {

    private let session = URLSession(configuration: .default)
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

    func send<RequestType: IRequest>(
        _ request: RequestType,
        parameters: RequestType.RequestParameters,
        completion: @escaping (Result<RequestType.ResponseContent, NetworkServiceError>) -> Void
    ) {
        do {
            let requestContainer = RequestContainer(parameters: parameters, token: token)
            let data = try JSONEncoder().encode(requestContainer)
            let url = config.endPoint.appendingPathComponent(request.method)
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
                    let result = try JSONDecoder().decode(ResponseContainer<RequestType.ResponseContent>.self, from: data)
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

extension Network {
    struct Config {
        static let `default` = Config(endPoint: URL(string: "http://176.57.214.20:8080")!)

        let endPoint: URL
    }
}
