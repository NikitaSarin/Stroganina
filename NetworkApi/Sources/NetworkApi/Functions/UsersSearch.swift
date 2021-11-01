//
//  UsersSearch.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

public struct UsersSearch {

    let name: String

    public init(name: String) {
        self.name = name
    }
}

extension UsersSearch: ApiFunction {

    public static var method = "user/search"

    public struct Response: Decodable {
        public let users: [Raw.User]
    }
}
