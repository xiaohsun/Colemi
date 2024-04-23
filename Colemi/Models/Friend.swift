//
//  Friend.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/20/24.
//

import Foundation
import FirebaseFirestore

// 很像不需要 Friend
struct Friend: Codable {
    let id: String
    let status: Int
    let time: Timestamp
    let chatRoom: String
}
