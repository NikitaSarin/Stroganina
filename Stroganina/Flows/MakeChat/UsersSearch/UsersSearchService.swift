//
//  UsersSearchService.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

protocol UsersSearchServiceProtocol {
    func fetch(with name: String, completion: @escaping (Result<[User], Error>) -> Void)
}

final class UsersSearchService: UsersSearchServiceProtocol {

    private let api: Networking

    init(api: Networking) {
        self.api = api
    }

    func fetch(with name: String, completion: @escaping (Result<[User], Error>) -> Void) {
        api.perform(UsersSearch(name: name)) { result in
            switch result {
            case .success(let response):
                completion(.success(response.users.map(User.init)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
