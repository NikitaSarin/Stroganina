//
//  Date+ServerTime.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import Foundation

extension Date {
    static var serverTime: UInt {
        return UInt(Date.timeIntervalBetween1970AndReferenceDate)
    }
}
