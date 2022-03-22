//
//  ChatService+MessagesPool.swift
//  Stroganina
//
//  Created by Alex Shipin on 22.03.2022.
//

extension ChatService {
    final class MessagesPool {
        private(set) var maxID: MessageIdentifier
        private(set) var minID: MessageIdentifier
        
        var containers: [MessageContainer] {
            didSet {
                guard !containers.isEmpty else {
                    return
                }
                self.maxID = containers[containers.count - 1].actualIdentifier
                self.minID = containers[0].actualIdentifier
                self.update()
            }
        }
        
        init?(containers: [MessageContainer]) {
            guard !containers.isEmpty else {
                return nil
            }
            self.containers = containers
            self.maxID = containers[containers.count - 1].actualIdentifier
            self.minID = containers[0].actualIdentifier
            self.update()
        }
        
        func separate(max: Int = 50) -> [MessagesPool] {
            var containers = self.containers
            var result = [MessagesPool]()
            while !containers.isEmpty {
                let subpool = MessagesPool(containers: Array(containers.prefix(max)))
                containers.removeFirst(min(max, containers.count))
                subpool.flatMap { result.append($0) }
            }
            return result
        }
        
        private func update() {
            for i in 0..<containers.count - 1{
                if i + 1 < containers.count - 1 {
                    containers[i].linkNext(containers[i + 1])
                }
            }
        }
    }
}
