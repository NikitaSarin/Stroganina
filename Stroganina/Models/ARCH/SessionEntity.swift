//
//  SessionEntity.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 03.06.2021.
//

struct SessionEntity: Identifiable {
    let id: Int64
    let isCurrent: Bool
    let applicationName: String
    let applicationVersion: String
    let deviceModel: String
    let platform: String
    let country: String
    let region: String
    let ip: String
    let date: Date
}

extension SessionEntity {
    static func mock(id: Int64 = 1, isCurrent: Bool = false) -> SessionEntity {
        SessionEntity(
            id: id,
            isCurrent: isCurrent,
            applicationName: "Telegram",
            applicationVersion: "3.0",
            deviceModel: "iPhone 12 Pro",
            platform: "iOS 14.5",
            country: "Russia",
            region: "Moscow",
            ip: "123.45.678.9",
            date: Date()
        )
    }
}
