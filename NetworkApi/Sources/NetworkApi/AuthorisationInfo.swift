//
//  AuthorisationInfo.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

public struct AuthorisationInfo: Encodable {
	public let token: String
	public let secretKey: String

	public init(token: String, secretKey: String) {
		self.token = token
		self.secretKey = String(secretKey.prefix(64))
	}
}
