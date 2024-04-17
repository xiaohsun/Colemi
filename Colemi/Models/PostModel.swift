//
//  PostsModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/16/24.
//

import Foundation
import FirebaseFirestore

struct PostModel {
    let authorId: String
    let color: String
    let colorSimularity: String
    let content: String
    let createdTime: Timestamp
    let id: String
    let reports: [String]
    let totalSaved: [String]
    let type: Int
    let imageUrl: String
}

enum Post: String {
    case authorId
    case color
    case colorSimularity
    case content
    case createdTime
    case id
    case reports
    case totalSaved
    case type
    case imageUrl
}
