//
//  GetUpdate.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

struct GetUpdate {
}

extension GetUpdate: ApiFunction {

    static var method = "update/get"
    static var longTimeOut: Bool = true

    struct Response: Decodable {
        enum NotificationTypeRaw: String, Decodable {
            case newMessage
            case addedInNewChat
        }
        
        enum Notification {
            case newMessage(_ message: MessageRaw)
            case addedInNewChat(_ chat: ChatRaw)
            case unknown
        }
    
        var notifications: [Notification]
    }
}

extension GetUpdate.Response.Notification: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try? container.decode(GetUpdate.Response.NotificationTypeRaw.self, forKey: .type)
        switch type {
        case .newMessage:
            self = .newMessage(try container.decode(MessageRaw.self, forKey: .content))
        case .addedInNewChat:
            self = .addedInNewChat(try container.decode(ChatRaw.self, forKey: .content))
        case .none:
            self = .unknown
        }
    }
    
    private enum CodingKeys : String, CodingKey {
        case type
        case content
    }
}
