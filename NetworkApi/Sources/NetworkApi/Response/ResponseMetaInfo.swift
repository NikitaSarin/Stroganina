//
//  ResponseMetaInfo.swift
//  
//
//  Created by Aleksandr Shipin on 05.11.2021.
//

struct ResponseMetaInfo: Decodable {
    let method: String
    let requestId: String?
}
