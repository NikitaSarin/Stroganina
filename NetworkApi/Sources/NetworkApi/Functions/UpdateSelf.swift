//
//  UpdateSelf.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 3.1.2021.
//

public struct UpdateSelf {
    let hex: String?
    let emoji: String?
    let firstName: String?
    let lastName: String?
    
    public init(
        hex: String?,
        emoji: String?,
        firstName: String?,
        lastName: String?
    ) {
        self.hex = hex
        self.emoji = emoji
        self.firstName = firstName
        self.lastName = lastName
    }
}

extension UpdateSelf: ApiFunction {

    public static var method = "user/update_self"

    public struct Response: Codable {
    }
}

