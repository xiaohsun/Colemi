//
//  Comment.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/23/24.
//

import Foundation

struct Comment: Codable {
    let id: String
    let postID: String
    let userID: String
    let avatarURL: String
    let userName: String
    let body: String
    let createdTime: String
}

enum CommentProperty: String {
    case id
    case postID
    case userID
    case userName
    case avatarURL
    case body
    case createdTime
}
