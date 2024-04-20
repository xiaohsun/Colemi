//
//  Chatroom.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/20/24.
//

import Foundation
import FirebaseFirestore

struct UserChatRoom: Codable {
    let id: String
    let latestMessage: String
    let receiver: String
    let latestMessageTime: Timestamp
}
