//
//  SimpleChatRoom.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/20/24.
//

import Foundation
import FirebaseFirestore

struct SimpleChatRoom: Codable {
    let id: String
    let receiverAvatarURL: String
    let latestMessage: String
    let latestMessageType: Int
    let receiverID: String
    let receiverName: String
    let latestMessageTime: Timestamp
}

enum SimpleChatRoomProperty: String {
    case id
    case receiverAvatarURL
    case latestMessage
    case latestMessageType
    case receiverID
    case receiverName
    case latestMessageTime
}
