//
//  log.swift
//  
//
//  Created by Aleksandr Shipin on 02.11.2021.
//

import Foundation
import CryptoKit

/// Нормальный логгер это конечно-же не замещает

public protocol LoggerOutput {
    func append(_ logs: [String])
}

public final class Logger {
    public static let `default` = Logger()
    @Locked public var allLogs = [String]()

    @Locked public var outputs: [LoggerOutput] = [ConsoleLog()]

    @Locked private var logs = [String]()
    @Locked public var timer: Timer?

    private let workQueue = DispatchQueue(label: "Logger.WorkQueue")

    func log(_ prefix: String = "", _ message: String) {
        workQueue.async {
            let message = message.components(separatedBy: "\n").map { prefix + $0 }.joined()
            self.logs.append(message)
            self.allLogs.append(message)
            self.$timer.mutate { timer in
                if timer == nil {
                    let newTimer = Timer(timeInterval: 1, repeats: false, block: { timer in
                        self.$timer.mutate { timer in
                            self.save()
                            timer = nil
                        }
                    })
                    timer = newTimer
                    RunLoop.main.add(newTimer, forMode: .default)
                }
            }
        }
    }

    private func save() {
        $logs.mutate { logs in
            self.outputs.forEach { output in
                output.append(logs)
            }
            logs = []
        }
    }
}

final class ConsoleLog: LoggerOutput {
    func append(_ logs: [String]) {
        logs.forEach { NSLog("\n%@", $0) }
    }
}

public func log(_ prefix: String = "", _ message: String) {
    Logger.default.log(prefix, message)
}
