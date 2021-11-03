//
//  UserSearchService.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import NetworkApi
import Foundation

protocol UserSearchServiceProtocol {
    func searchUsers(
        with name: String,
        completion: @escaping (Result<[User], Error>) -> Void
    )
}

final class UserSearchService: UserSearchServiceProtocol {

    private let api: Networking
    private let sceduler: Scheduler

    init(api: Networking, scheduleDelay: TimeInterval = 0.5) {
        self.api = api
        self.sceduler = Scheduler(defaultDelay: scheduleDelay)
    }

    func searchUsers(with name: String, completion: @escaping (Result<[User], Error>) -> Void) {
        sceduler.schedule { [weak self, name] in
            self?.api.perform(UserSearch(name: name)) { result in
                switch result {
                case .success(let response):
                    completion(.success(response.users.map(User.init)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
