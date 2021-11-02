//
//  RegistrationViewModel.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation

final class RegistrationViewModel: ObservableObject {

    @Published var username = ""
    @Published var password = ""

    private let router: AuthRouting
    private let service: RegistrationServiceProtocol

    init(
        router: AuthRouting,
        service: RegistrationServiceProtocol
    ) {
        self.router = router
        self.service = service
    }

    func registerButtonTapped() {
        service.register(with: username, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.router.openMainFlow(animated: true)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
