//
//  UserLogout.swift
//  
//
//  Created by Alex Shipin on 19.03.2022.
//

public struct UserLogout {
    public init() {}
}

extension UserLogout: ApiFunction {

    public static var method = "user/logout"

    public struct Response: Codable {
    }
}

