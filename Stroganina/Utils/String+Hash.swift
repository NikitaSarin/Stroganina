//
//  String+Hash.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import CryptoKit

extension String {
    func hash(with time: UInt) -> String {
        guard let data = self.data(using: .utf8) else {
            assertionFailure("Not generate data for hash")
            return ""
        }
        let hash = SHA512.hash(data: data).map({ String(format:"%02x", UInt8($0)) }).joined()
        return hash
    }
    
    var cleanHash: String {
        guard let data = self.data(using: .utf8) else {
            assertionFailure("Not generate data for hash")
            return ""
        }
        let hash = SHA512.hash(data: data).map({ String(format:"%02x", UInt8($0)) }).joined()
        return hash
    }
}
