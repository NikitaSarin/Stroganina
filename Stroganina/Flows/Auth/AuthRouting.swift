//
//  AuthRouting.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation

protocol AuthRouting {
    func openLoginScene()
    func openRegistrationScene()
    func openMainFlow(animated: Bool)
}

struct AuthRouterMock: AuthRouting {
    func openLoginScene() {}
    func openRegistrationScene() {}
    func openMainFlow(animated: Bool) {}
}
