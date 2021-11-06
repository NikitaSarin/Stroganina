//
//  DefaultResponseHandler.swift
//  
//
//  Created by Aleksandr Shipin on 05.11.2021.
//

import Foundation

final class DefaultResponseHandler<Content: Decodable>: ResponseHandler {
    let identifeir: ResponseHandlerIdentifier

    private let method: String
    private let handler: (Result<Content, ApiError>) -> Void
    private let queue: DispatchQueue

    init(
        reuestId: String?,
        method: String,
        queue: DispatchQueue,
        handler: @escaping (Result<Content, ApiError>) -> Void
    ) {
        if let reuestId = reuestId {
            identifeir = .request(reuestId: reuestId)
        } else {
            identifeir = .listener(method: method)
        }
        self.method = method
        self.handler = handler
        self.queue = queue
    }

    func handler(data: Data?, error: Error?) {
        if let error = error {
            log("[API][\(method)][ERROR]", "\(error)")
            completion(.failure(.networkError(error)))

            return
        }
        guard let data = data else {
            log("[API][\(method)][ERROR]", "data is empty")
            completion(.failure(.decodingError))
            return
        }
        do {
            log("[API][\(method)][RESPONSE]", String(data: data, encoding: .utf8) ?? "")
            let result = try JSONDecoder().decode(Response<Content>.self, from: data)
            if let content = result.content {
                completion(.success(content))
                return
            }
            if let error = result.errors?.first {
                completion(.failure(.userError(error)))
                return
            }
            completion(.failure(.decodingError))
        }
        catch {
            completion(.failure(.networkError(error)))
        }
    }

    private func completion(_ result: Result<Content, ApiError>) {
        queue.async {
            self.handler(result)
        }
    }
}
