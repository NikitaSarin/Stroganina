//
//  PollMessage.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 29.05.2021.
//

final class PollMessage: BaseMessage {

    struct Option {
        let text: String
        let percent: Int
        let isChosen: Bool
    }

    enum Mode {
        case regular(allowMultipleAnwsers: Bool)
        case quiz(correctOptionIndex: Int)

        var allowMultipleAnwsers: Bool {
            switch self {
            case .quiz:
                return false
            case let .regular(allowMultipleAnwsers):
                return allowMultipleAnwsers
            }
        }

        var correctIndex: Int? {
            switch self {
            case let .quiz(index):
                return index
            case .regular:
                return nil
            }
        }
    }

    let isAnonymous: Bool
    let isClosed: Bool
    let question: String
    var options: [Option]
    let mode: Mode

    init(
        base: BaseMessage,
        isAnonymous: Bool,
        isClosed: Bool,
        question: String,
        options: [Option],
        mode: Mode
    ) {
        self.isAnonymous = isAnonymous
        self.isClosed = isClosed
        self.question = question
        self.options = options
        self.mode = mode
        super.init(base)
    }
}
