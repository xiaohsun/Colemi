//
//  Post.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/16/24.
//

import Foundation
import FirebaseFirestore

struct Post: Codable {
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
    let imageHeight: Double
    let imageWidth: Double
    let comments: [Comment]
}

enum PostProperty: String {
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
    case imageHeight
    case imageWidth
    case comments
}
