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
    var id = "6ZEYl7jlzOKtOWr7RzT9"
    var name = "柏勳一號"
    var posts: [String] = []
    var likes: [String] = []
    var avatarPhoto = ""
    var friends: [String] = []
    var description = ""
    var savedPosts: [String] = []
    var signUpTime = Timestamp()
    var lastestLoginTime = Timestamp()
    var colorToday = ""
    var chatRooms: [String] = []
    var followers: [String] = []
    var following: [String] = []
}
