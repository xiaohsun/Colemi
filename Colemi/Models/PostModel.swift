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
}

enum P: String {
    case authorId = "authorId"
    case color = "color"
    case colorSimularity = "colorSimularity"
    case content = "content"
    case createdTime = "createdTime"
    case id = "id"
    case reports = "reports"
    case totalSaved = "totalSaved"
    case type = "type"
}
