//
//  LocationMessage.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 30.05.2021.
//

import TDLib

final class LocationMessage: BaseMessage {

    let location: Location
    let isExpired: Bool
    let isLive: Bool
    let text: String?

    init(
        base: BaseMessage,
        location: Location,
        livePeriod: Int,
        text: String?
    ) {
        self.location = location
        self.isLive = livePeriod > 0
        let expireTimestamp = base.date.addingTimeInterval(Double(livePeriod)).timeIntervalSince1970
        let currentTimestamp = Date().timeIntervalSince1970
        let isExpired = currentTimestamp > expireTimestamp
        self.isExpired = isExpired
        self.text = (isLive && !isExpired) ? "Live Location" : text
        super.init(base)
    }
}
