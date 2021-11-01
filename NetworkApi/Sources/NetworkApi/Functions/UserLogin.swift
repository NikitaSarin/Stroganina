//
//  UserLogin.swift
//  StroganinaNetwork
//
//  Created by Denis Kamkin on 28.10.2021.
//

public struct UserLogin {

    let name: String
    let securityHash: String
    let userPublicKey: String

    public init(name: String, securityHash: String, userPublicKey: String) {
        self.name = name
        self.securityHash = securityHash
        self.userPublicKey = userPublicKey
    }
}

extension UserLogin: ApiFunction {

    public static var method = "user/login"

    public struct Response: Decodable {
        public let token: String
        public let serverPublicKey: String
        public let userId: ID
    }
}
