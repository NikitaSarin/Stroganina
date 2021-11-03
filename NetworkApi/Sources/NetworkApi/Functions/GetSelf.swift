//
//  GetSelf.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 3.1.2021.
//

public struct GetSelf {
    public init() {
    }
}

extension GetSelf: ApiFunction {

    public static var method = "user/get_self"

    public typealias Response = Raw.User
}
