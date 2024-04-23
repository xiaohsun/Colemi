//
//  Comment.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/23/24.
//

import Foundation

struct Comment<T: Codable>: Codable {
    let id: String
    let postID: String
    let userID: String
    let avatarURL: String
    let body: String
    let time: T
}
