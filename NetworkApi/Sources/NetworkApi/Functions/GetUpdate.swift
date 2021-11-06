//
//  GetUpdate.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

public struct AddListenerUpdate {
    public init() {}
}

extension AddListenerUpdate: ApiFunction {
    public static var method = "update/add_listener"
    public static var wayType: RequestWayType {
        .ws
    }
    
    public struct Response: Decodable { }
}

public struct GetUpdate {
    public init() {}
}

extension GetUpdate: ApiListener {
    public static var method = "update"

    public struct Response: Decodable {
        public enum NotificationTypeRaw: String, Decodable {
            case newMessage
            case addedInNewChat
        }
        
        public enum Notification {
            case newMessage(_ message: Raw.Message)
            case addedInNewChat(_ chat: Raw.Chat)
            case unknown
        }
    
        public var notifications: [Notification]
    }
}
extension GetUpdate.Response.Notification: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try? container.decode(GetUpdate.Response.NotificationTypeRaw.self, forKey: .type)
        switch type {
        case .newMessage:
            self = .newMessage(try container.decode(Raw.Message.self, forKey: .content))
        case .addedInNewChat:
            self = .addedInNewChat(try container.decode(Raw.Chat.self, forKey: .content))
        case .none:
            self = .unknown
        }
    }
    
    private enum CodingKeys : String, CodingKey {
        case type
        case content
    }
}
