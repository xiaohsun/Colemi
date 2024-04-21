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
    let friends: [String]
    let description: String
    let savedPosts: [String]
    let signUpTime: Timestamp
    let lastestLoginTime: Timestamp
    let colorToday: String
    let chatRooms: [SimpleChatRoom]
    let followers: [String]
    let following: [String]
}

enum UserProperty: String {
    case id
    case name
    case posts
    case likes
    case avatarPhoto
    case friends
    case description
    case savedPosts
    case signUpTime
    case lastestLoginTime
    case colorToday
    case chatRooms
    case followers
    case following
}

struct ChatRoom: Codable {
}
