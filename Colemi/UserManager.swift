//
//  UserManager.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/12/24.
//

import UIKit
import FirebaseFirestore

class UserManager {
    
    static let shared = UserManager()
    
    var selectedColor: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)?
    var selectedUIColor: UIColor?
    var selectedHexColor: String?
    var id = FakeUserData.shared.userOneID
    var name = "柏勳一號"
    var posts: [String] = []
    var likes: [String] = []
    var avatarPhoto = ""
    var description = ""
    var savedPosts: [String] = []
    var signUpTime = Timestamp()
    var lastestLoginTime = Timestamp()
    var colorToday = "#A6EDED"
    var colorSetToday: [String] = ["#A6EDED", "#FEFFA8", "#FF8A8A"]
    var mixColorToday = ""
    var chatRooms: [SimpleChatRoom] = []
    var followers: [String] = []
    var following: [String] = []
    var blocking: [String] = []
    var beBlocked: [String] = []
    var didUserPostToday: Bool = false
    var status: Int = 1
}
