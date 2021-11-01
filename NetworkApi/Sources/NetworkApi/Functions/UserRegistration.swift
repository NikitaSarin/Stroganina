//
//  UserRegistration.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

public struct UserRegistration {

    let name: String
    let securityHash: String
    let userPublicKey: String

    public init(name: String, securityHash: String, userPublicKey: String) {
        self.name = name
        self.securityHash = securityHash
        self.userPublicKey = userPublicKey
    }
}

extension UserRegistration: ApiFunction {

    public static var method = "user/registration"

    public struct Response: Decodable {
        public let token: String
        public let serverPublicKey: String
        public let userId: ID
    }
}

