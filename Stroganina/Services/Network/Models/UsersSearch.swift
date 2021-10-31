//
//  UsersSearch.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import Foundation

struct UsersSearch {
    let name: String
}

extension UsersSearch: ApiFunction {

    static var method = "user/search"

    struct Response: Decodable {
        let users: [UserRaw]
    }
}
