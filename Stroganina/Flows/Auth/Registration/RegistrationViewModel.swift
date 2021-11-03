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
    private let pushService: PushServiceProtocol

    init(
        router: AuthRouting,
        service: RegistrationServiceProtocol,
        pushService: PushServiceProtocol
    ) {
        self.router = router
        self.service = service
        self.pushService = pushService
    }

    func registerButtonTapped() {
        service.register(with: username, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.pushService.requestPush()
                self?.router.openMainFlow(animated: true)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
