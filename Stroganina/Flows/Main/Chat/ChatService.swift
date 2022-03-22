//
//  ChatService.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import Foundation
import NetworkApi
import SwiftUI


protocol ChatServiceProtocol {
    func load(_ handler: @escaping (([MessageItem]) -> Void))
    func send(text: String, completion: @escaping BoolClosure)
    func useItem(_ item: MessageItem)
}

final class ChatService: ChatServiceProtocol {
    private var updateHandler: (([MessageItem]) -> Void)?

    private let queue = DispatchQueue(label: "storage.queue")
    private var pools: [MessagesPool] = []
    
    private let api: Networking
    private let chatId: Chat.ID
    private let updateCenter: UpdateCenter
    private let padgeSize = 30

    private var topLoaded: Bool = false
    private var bottomLoaded: Bool = false
    
    private var loading = Set<String>()

    init(
        chatId: Chat.ID,
        api: Networking,
        updateCenter: UpdateCenter
    ) {
        self.chatId = chatId
        self.api = api
        self.updateCenter = updateCenter
        
        updateCenter.addListener(self)
    }
    
    func useItem(_ item: MessageItem) {
        self.queue.async {
            switch item {
            case .new(let id, let reverse):
                if !self.loading.contains(item.id) {
                    self.loading.insert(item.id)
                    self.fetch(from: id, reverse: reverse) {
                        self.queue.async {
                            self.loading.remove(item.id)
                        }
                    }
                }
            case .empty(let id, let reverse):
                if !self.loading.contains(item.id) {
                    self.loading.insert(item.id)
                    self.fetch(from: id, reverse: reverse) {
                        self.queue.async {
                            self.loading.remove(item.id)
                        }
                    }
                }
            case .message:
                break
            }
        }
    }
    
    func send(text: String, completion: @escaping BoolClosure) {
        let message = Message(type: .text, content: text, chatId: chatId)
        let function = NewMessage(
            type: message.type,
            content: message.content,
            chatId: message.chatId
        )
        queue.async {
            self.update([message])
        }
        api.perform(function) { [weak self] result in
            switch result {
            case .success(let response):
                self?.queue.async {
                    self?.sendedMessage(Message(raw: response, id: message.identifier))
                }
                self?.updateCenter.sendNotification(.newMessage(response))
                completion(true)
            case let .failure(error):
                print(error)
                completion(false)
            }
        }
    }
    
    func load(_ handler: @escaping (([MessageItem]) -> Void)) {
        queue.async {
            self.updateHandler = handler
            self.didUpdate()
        }
    }
    
    private func outOfSync() {
        queue.async {
            self.bottomLoaded = false
            self.didUpdate()
        }
    }
    
    private func fetch(from messageId: ID?, reverse: Bool = false, completion: @escaping () -> Void) {
        let function = GetMessages(
            chatId: chatId,
            limit: padgeSize,
            lastMessageId: messageId,
            reverse: reverse
        )
        api.perform(function) { [weak self, padgeSize] result in
            switch result {
            case let .success(response):
                self?.queue.async {
                    if response.messages.count < padgeSize {
                        if reverse {
                            self?.bottomLoaded = true
                        } else {
                            self?.topLoaded = true
                        }
                    }
                    if messageId == nil {
                        if reverse {
                            self?.topLoaded = true
                        } else {
                            self?.bottomLoaded = true
                        }
                    }
                    self?.update(raws: response.messages)
                    completion()
                }
            case let .failure(error):
                print(error)
                self?.queue.async {
                    completion()
                }
            }
        }
    }
    
    private func update(raws: [Raw.Message]) {
        queue.async {
            self.update(raws.map { ChatService.Message(raw: $0, id: nil) })
        }
    }
    
    private func addNewMessage(_ message: Message) {
        queue.async {
            guard self.bottomLoaded else {
                self.update([message])
                return
            }
            if let pool = self.pools.last(where: { $0.containers.last?.message.messageId != nil }) {
                pool.containers.append(MessageContainer(message: message))
                self.didUpdate()
            } else {
                self.update([message])
            }
        }
    }
    
    private func didUpdate() {
        var items = [MessageItem]()

        for pool in pools {
            if pool.containers.first?.message.messageId == nil {
                if case let .empty(id, reverse) = items.last {
                    items.removeLast()
                    if !bottomLoaded {
                        items.append(.new(id: id, reverse: reverse))
                    }
                }
                if items.isEmpty {
                    items.append(.new(id: nil, reverse: false))
                }
            }
            if let first = pool.containers.first, first.message.backID == nil, let id = first.message.messageId {
                if !(items.isEmpty && self.topLoaded) {
                    items.append(.empty(id: id, reverse: false))
                }
            }
            let messages = pool.containers.map { MessageItem.message(message: $0.messageWrapper) }
            items.append(contentsOf: messages)
            if let last = pool.containers.last, last.message.nextID == nil, let id = last.message.messageId {
                items.append(.empty(id: id, reverse: true))
            }
        }
        if case .empty(let id, _) = items.last {
            items.removeLast()
            if !bottomLoaded {
                items.append(.new(id: id, reverse: true))
            }
        }
        if items.isEmpty {
            items.append(.new(id: nil, reverse: false))
        }

        self.updateHandler?(items.reversed())
    }
    
    private func sendedMessage(_ message: Message) {
        pools.removeAll(where: { $0.containers.contains(where: { $0.message.identifier == message.identifier })})
    }

    private func update(_ inputs: [Message]) {
        guard !inputs.isEmpty else {
            return
        }
        defer {
            didUpdate()
        }
        var messages = inputs.map({ MessageContainer(message: $0) }).sorted(by: { $0.actualIdentifier < $1.actualIdentifier })
        
        let index = (pools.firstIndex(where: { $0.minID >= messages[0].actualIdentifier }))
        
        guard let index = index else {
            MessagesPool(containers: messages).flatMap { pools.append($0) }
            return
        }
        
        var result = [MessageContainer]()
        while index < pools.count, !messages.isEmpty, pools[index].minID <= messages[messages.count - 1].actualIdentifier {
            let pool = pools[index]
            pools.remove(at: index)
            
            for container in pool.containers {
                while !messages.isEmpty && messages[0].actualIdentifier < container.actualIdentifier {
                    result.append(messages[0])
                    messages.removeFirst()
                }
                if !messages.isEmpty && container.actualIdentifier < messages[0].actualIdentifier {
                    result.append(container)
                } else if !messages.isEmpty && container.actualIdentifier == messages[0].actualIdentifier {
                    var message = messages[0].message
                    message.nextID = container.message.nextID
                    message.backID = container.message.backID
                    container.message = message
                    result.append(container)
                    messages.removeFirst()
                } else if messages.isEmpty {
                    result.append(container)
                }
            }
        }
        while !messages.isEmpty {
            result.append(messages[0])
            messages.removeFirst()
        }
        if let newPools = MessagesPool(containers: result)?.separate(max: padgeSize) {
            pools.insert(contentsOf: newPools, at: index)
        }
    }
}

extension ChatService: Listener {
    func update(_ notifications: [Notification]) {
        for notification in notifications {
            switch notification {
            case .newMessage(let message):
                if message.chatId == chatId {
                    addNewMessage(.init(raw: message, id: nil))
                }
            case .closeConnect:
                outOfSync()
            default:
                break
            }
        }
    }
}

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
    
    final class MessageContainer {
        var actualIdentifier: MessageIdentifier {
            if let remoteId = message.messageId {
                return .remote(id: remoteId)
            }
            return message.identifier
        }
        lazy var messageWrapper: MessageWrapper = {
            MessageWrapper(message)
        }()
    
        var message: Message {
            didSet {
                DispatchQueue.main.async {
                    self.messageWrapper.type = .init(self.message)
                }
            }
        }
        
        internal init(message: Message) {
            self.message = message
        }
        
        func linkNext(_ container: MessageContainer) {
            guard container.message.messageId != nil, self.message.messageId != nil else {
                return
            }
            self.message.nextID = container.message.identifier
            container.message.backID = self.message.identifier
        }
        
        func linkBack(_ container: MessageContainer) {
            guard container.message.messageId != nil, self.message.messageId != nil else {
                return
            }
            self.message.backID = container.message.identifier
            container.message.nextID = self.message.identifier
        }
    }

    enum MessageStatus: Codable, UnknownSafable {
        case watingSend
        case sended
        case failed
        case read
        case unknown
    }

    public enum MessageIdentifier: Codable {
        case local(time: UInt64, id: UInt64)
        case remote(id: ID)
    }

    public struct Message: Codable {
        var nextID: MessageIdentifier?
        var backID: MessageIdentifier?
        let identifier: MessageIdentifier
        let user: Raw.User?
        let date: UInt
        let content: String
        let messageId: ID?
        let chatId: ID
        @SafeCodable var status: MessageStatus
        @SafeCodable var type: Raw.MessageType
    }
}

extension ChatService.Message {
    init(type: Raw.MessageType, content: String, chatId: ID) {
        self.identifier = Self.nextLocalIdentifier
        self.content = content
        self.chatId = chatId
        self.type = type
        self.status = .watingSend
        self.date = UInt(Date().timeIntervalSince1970)
        self.user = nil
        self.messageId = nil
    }
    
    init(raw: Raw.Message, id: ChatService.MessageIdentifier?) {
        self.identifier = id ?? .remote(id: raw.messageId)
        self.content = raw.content
        self.chatId = raw.chatId
        self.type = raw.type
        self.status = .sended
        self.date = raw.date
        self.user = raw.user
        self.messageId = raw.messageId
    }
}

extension ChatService.Message {
    private static let workQueue = DispatchQueue(label: "ChatService.Message.workQueue")
    private static var localCount: UInt64 = 0
    
    static var nextLocalIdentifier: ChatService.MessageIdentifier {
        var id: UInt64 = 0
        workQueue.sync {
            id = localCount
            localCount += 1
        }
        return .local(time: UInt64(Int64(Date().timeIntervalSince1970)), id: id)
    }
}

extension ChatService.MessageIdentifier: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.local(let t1, let i1), .local(let t2, let i2)):
            return t1 < t2 || (t1 == t2 && i1 < i2)
        case (.remote(let id1), .remote(let id2)):
            return id1 < id2
        case (.remote, .local):
            return true
        case (.local, .remote):
            return false
        }
    }
    
    static func > (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.local(let t1, let i1), .local(let t2, let i2)):
            return t1 > t2 || (t1 == t2 && i1 > i2)
        case (.remote(let id1), .remote(let id2)):
            return id1 > id2
        case (.remote, .local):
            return false
        case (.local, .remote):
            return true
        }
    }

    static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs < rhs || lhs == rhs
    }

    static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs > rhs || lhs == rhs
    }
}

extension Message {
    convenience init(_ message: ChatService.Message) {
        self.init(
            id: "\(message.identifier)",
            date: Date(timeIntervalSince1970: TimeInterval(message.date)),
            user: message.user.flatMap { User($0) },
            isOutgoing: message.user?.isSelf ?? true,
            chatId: message.chatId,
            state: .init(message.status)
        )
    }
}

extension Message.MessageState {
    init(_ status: ChatService.MessageStatus) {
        switch status {
        case .watingSend:
            self = .watingSend
        case .sended:
            self = .sended
        case .failed:
            self = .failed
        case .read:
            self = .read
        case .unknown:
            self = .unknown
        }
    }
}

extension MessageType {
    init(_ message: ChatService.Message) {
        let base = Message(message)
        switch message.type {
        case .text:
            if message.content.isSingleEmoji {
                self = .emoji(TextMessage(base: base, text: message.content))
            } else {
                self = .text(TextMessage(base: base, text: message.content))
            }
        case .service:
            self = .service(TextMessage(base: base, text: message.content))
        case .unknown:
            self = .service(TextMessage(base: base, text: "Unknown message type"))
        }
    }
}

enum MessageItem: Identifiable {
    case new(id: ID?, reverse: Bool)
    case empty(id: ID, reverse: Bool)
    case message(message: MessageWrapper)
    
    var id: String {
        switch self {
        case let .new(id, reverse):
            return "new\(id ?? 0)\(reverse)"
        case let .empty(id, reverse):
            return "empty\(id)\(reverse)"
        case let .message(message):
            return "message\(message.id)"
        }
    }
}

extension MessageWrapper {
    convenience init(_ message: ChatService.Message) {
        self.init(type: MessageType(message))
    }
}

extension ChatService {
    struct Mock: ChatServiceProtocol {
        func useItem(_ item: MessageItem) { }
        func load(_ handler: @escaping (([MessageItem]) -> Void)) { }
        func send(text: String, completion: @escaping BoolClosure) {}
    }
}
