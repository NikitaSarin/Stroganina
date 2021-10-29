//
//  ChatService.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation

final class ChatService: ChatServiceProtocol {

    var allMessagesFetched: Bool = true
    weak var delegate: ChatServiceDelegate?

    private let api: Networking

    init(api: Networking) {
        self.api = api
    }

    func fetch(from messageId: Message.ID?) {
        let function = GetMessages(
            chatId: 1,
            limit: 20,
            lastMessageId: nil,
            reverse: false
        )
        api.perform(function) { [weak delegate] result in
            switch result {
            case let .success(response):
                let wrappers = response.messages.map {
                    MessageWrapper(type: .text(TextMessage(response: $0)))
                }
                delegate?.didChange(messages: wrappers)
            case let .failure(error):
                print(error)
            }
        }
    }
}

private extension TextMessage {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    convenience init(response: GetMessages.Response.Message) {
        let date = Date(timeIntervalSince1970: TimeInterval(response.date))
        let base = Message(
            id: response.messageId,
            time: TextMessage.formatter.string(from: date),
            user: nil,
            isOutgoing: response.user.isSelf,
            showSenders: true,
            chatId: response.chatId
        )
        self.init(base: base, text: response.content)
    }
}
