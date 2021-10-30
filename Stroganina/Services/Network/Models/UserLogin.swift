//
//  UserLogin.swift
//  StroganinaNetwork
//
//  Created by Denis Kamkin on 28.10.2021.
//

struct UserLogin {
    let name: String
    let securityHash: String
    let userPublicKey: String
}

extension UserLogin: ApiFunction {

    static var method = "user/login"

    struct Response: Decodable {
        let token: String
        let serverPublicKey: String
        let userId: User.ID
    }
}
