//
//  MessagesPage.swift
//  Stroganina
//
//  Created by Alex Shipin on 22.03.2022.
//

extension ChatService {
    final class MessagesPage {
        private(set) var maxID: MessageIdentifier
        private(set) var minID: MessageIdentifier

        var messages: [MessageNode] {
            didSet {
                guard !messages.isEmpty else {
                    return
                }
                self.maxID = messages[messages.count - 1].actualIdentifier
                self.minID = messages[0].actualIdentifier
                self.update()
            }
        }

        init?(messages: [MessageNode]) {
            guard !messages.isEmpty else {
                return nil
            }
            self.messages = messages
            self.maxID = messages[messages.count - 1].actualIdentifier
            self.minID = messages[0].actualIdentifier
            self.update()
        }

        func separate(max: Int = 50) -> [MessagesPage] {
            var messages = self.messages
            var result = [MessagesPage]()
            while !messages.isEmpty {
                let subpage = MessagesPage(messages: Array(messages.prefix(max)))
                messages.removeFirst(min(max, messages.count))
                subpage.flatMap { result.append($0) }
            }
            return result
        }

        private func update() {
            for i in 0..<messages.count - 1{
                if i + 1 < messages.count - 1 {
                    messages[i].linkNext(messages[i + 1])
                }
            }
        }
    }
}
