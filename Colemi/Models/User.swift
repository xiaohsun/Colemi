//
//  User.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import Foundation
import FirebaseFirestore

struct User: Codable {
    let id: String
    let name: String
    let posts: [String]
    let likes: [String]
    let avatarPhoto: String
    let friend: [Friend]
    let description: String
    let savePosts: [String]
    let signUpTime: TimeInterval
    let lastestLoginTime: TimeInterval
    let colorToday: String
    let chatRooms: [ChatRoom]
    let followers: [String]
    let following: [String]
}

struct Friend: Codable {
}

struct ChatRoom: Codable {
}
