//
//  UserLogin.swift
//  StroganinaNetwork
//
//  Created by Denis Kamkin on 28.10.2021.
//

struct UserLogin {
    let name: String
}

extension UserLogin: ApiFunction {
    struct Response: Decodable {
        let token: String
        let userId: Int
    }
    static var method = "user/login"
}
