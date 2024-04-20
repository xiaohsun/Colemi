//
//  Friend.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/20/24.
//

import Foundation
import FirebaseFirestore

struct Friend: Codable {
    let id: String
    let status: Int
    let time: Timestamp
    let chatRoom: String
}
