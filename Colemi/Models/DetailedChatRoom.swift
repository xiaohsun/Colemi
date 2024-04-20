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

enum DetailedChatRoomProperty {
    case id
    case receiverAvatarURL
    case latestMessage
    case receiver
    case latestMessageTime
}

struct Message: Codable {
    let id: String
    let senderID: String
    let body: String
    let time: Timestamp
}

enum MessageProperty {
    case id
    case senderID
    case body
    case time
}
