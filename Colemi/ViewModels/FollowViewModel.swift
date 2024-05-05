//
//  FollowViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/5/24.
//

import Foundation

class FollowViewModel {
    
    let userData = UserManager.shared
    
    var followings: [String] = []
    var followers: [String] = []
    
    var followersAvatarUrls: [String] = []
    var followersNames: [String] = []
    
    var followingsAvatarUrls: [String] = []
    var followingsNames: [String] = []
    
    func getFollowData(userIDs: [String], getFollowers: Bool, completion: @escaping() -> Void) async {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.users.ref
        
        if getFollowers {
            self.followersAvatarUrls = []
            self.followersNames = []
        } else {
            self.followingsAvatarUrls = []
            self.followingsNames = []
        }
        
        // 一次只能 30 筆，要改
        let users: [User] = await firestoreManager.getMultipleDocument(collection: ref, docIDs: userIDs)
        
        for user in users {
            if getFollowers {
                self.followersAvatarUrls.append(user.avatarPhoto)
                self.followersNames.append(user.name)
            } else {
                self.followingsAvatarUrls.append(user.avatarPhoto)
                self.followingsNames.append(user.name)
            }
        }
        completion()
    }
}
