//
//  LoginViewModel.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Combine
import Foundation

protocol LoginServiceProtocol {
    func login(
        with username: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class LoginViewModel: ObservableObject {

    @Published var username = "alex8"

    private let router: AuthRouting
    private let service: LoginServiceProtocol

    init(
        router: AuthRouting,
        service: LoginServiceProtocol
    ) {
        self.router = router
        self.service = service
    }

    func loginButtonTapped() {
        service.login(with: username) { [weak self] result in
            switch result {
            case .success:
                self?.router.openMainFlow()
            case let .failure(error):
                print(error.localizedDescription)
            }

        }
    }
}