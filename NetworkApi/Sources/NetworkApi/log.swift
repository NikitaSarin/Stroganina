//
//  log.swift
//  
//
//  Created by Aleksandr Shipin on 02.11.2021.
//

import Foundation

/// Нормальный логгер это конечно-же не замещает

func log(_ prefix: String = "", _ message: String) {
    let message = message.components(separatedBy: "\n").map { prefix + $0 }.joined()
    NSLog("\n%@", message)
}
