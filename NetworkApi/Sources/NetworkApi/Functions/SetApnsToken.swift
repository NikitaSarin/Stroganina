//
//  File.swift
//  
//
//  Created by Aleksandr Shipin on 04.11.2021.
//

public struct SetApnsToken {
    let token: String
    
    public init(token: String) {
        self.token = token
    }
}

extension SetApnsToken: ApiFunction {
    public static var method: String {
        "user/set_apns_token"
    }
    
    public struct Response: Codable {
    }
}
