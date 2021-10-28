//
//  UserLogin.swift
//  StroganinaNetwork
//
//  Created by Denis Kamkin on 28.10.2021.
//

enum UserLogin {
    struct Input: Codable {
        let name: String
    }

    struct Output: Codable {
        let token: String
        let userId: Int
    }
}

typealias UserLoginRequest = Request<UserLogin.Input, UserLogin.Output>

extension Request {
	static var userLogin: UserLoginRequest {
		UserLoginRequest(method: "user/login")
	}
}
