//
//  UserRegistration.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

struct UserRegistration {
    let name: String
    let securityHash: String
    let userPublicKey: String
}

extension UserRegistration: ApiFunction {

    static var method = "user/registration"

    struct Response: Decodable {
        let token: String
        let serverPublicKey: String
        let userId: User.ID
    }
}

