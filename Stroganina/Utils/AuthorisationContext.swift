//
//  AuthorisationContext.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import CryptoKit
import Foundation

final class AuthorisationContext {
    var publicUserKey: String {
        userPrivateKey.publicKey.pemRepresentation
    }
    
    var securityHash: String {
        (username + password).cleanHash
    }

    private let store: Store
    private let userPrivateKey = P521.KeyAgreement.PrivateKey()
    private let username: String
    private let password: String

    init(store: Store, username: String, password: String) {
        self.store = store
        self.username = username
        self.password = password
    }

    func success(
        serverPublicKey: String,
        token: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard
            let key = try? generateKey(uuid: token, serverPublicKey: serverPublicKey)
        else {
            completion(.failure(AuthorisationContextError.generateKeyError))
            return
        }
        self.store.set(
            authorisationInfo: AuthorisationInfo(
                token: token,
                secretKey: key
            )
        )
        completion(.success(()))
    }

    private func generateKey(
        uuid: String,
        serverPublicKey: String
    ) throws -> String? {
        guard let salt = uuid.data(using: .utf8) else {
            return nil
        }
        let serverPublicKey = try P521.KeyAgreement.PublicKey(
            pemRepresentation: serverPublicKey
        )
        let userSharedSecret = try userPrivateKey.sharedSecretFromKeyAgreement(with: serverPublicKey)
        let secretSymmetricKey = userSharedSecret.hkdfDerivedSymmetricKey(
            using: SHA256.self,
            salt: salt,
            sharedInfo: Data(),
            outputByteCount: 32
        )
        let symmetricKey = secretSymmetricKey.withUnsafeBytes {
            return Data(Array($0)).base64EncodedString().cleanHash
        }
        return symmetricKey
    }
}

extension AuthorisationContext {
    enum AuthorisationContextError: Error {
        case generateKeyError
    }
}
