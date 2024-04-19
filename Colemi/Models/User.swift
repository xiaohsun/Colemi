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
    let savePosts: [String]
    let signUpTime: Timestamp
    let lastestLoginTime: Timestamp
    let colorToday: String
    let chatRooms: [String]
    let followers: [String]
    let following: [String]
}

struct Friend: Codable {
}

struct ChatRoom: Codable {
}
