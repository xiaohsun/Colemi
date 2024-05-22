//
//  DetailedChatRoom.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/20/24.
//

import Foundation
import FirebaseFirestore

struct DetailedChatRoom: Codable {
    let id: String
    let userOneID: String
    let userTwoID: String
    let messages: [Message]
}

enum DetailedChatRoomProperty: String {
    case id
    case userOneID
    case userTwoID
    case messages
}

struct Message: Codable {
    let id: String
    let senderID: String
    let body: String
    let time: Timestamp
    let type: Int
}

enum MessageProperty: String {
    case id
    case senderID
    case body
    case time
    case type
}
