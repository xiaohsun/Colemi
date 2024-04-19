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
    var id = ""
    var name = ""
    var posts: [String] = []
    var likes: [String] = []
    var avatarPhoto = ""
    var friends: [String] = []
    var description = ""
    var savePosts: [String] = []
    var signUpTime = Timestamp()
    var lastestLoginTime = Timestamp()
    var colorToday = ""
    var chatRooms: [String] = []
    var followers: [String] = []
    var following: [String] = []
}
