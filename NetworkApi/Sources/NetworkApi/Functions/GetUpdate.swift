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
        public enum Notification: Decodable {
            case newMessage(message: Raw.Message)
            case newChat(chat: Raw.Chat)
        }
    
        public var notifications: [SafeCodableContainer<Notification>]
    }
}
