//
//  ProfileViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/19/24.
//

import UIKit
import Kingfisher
import FirebaseFirestore

class ProfileViewModel {
    
    
    
    var posts: [Post] = []
    var saves: [Post] = []
    var images: [UIImage] = []
    var myPostsSizes: [CGSize] = []
    var mySavesSizes: [CGSize] = []
    var contentJSONString: [String] = []
    var savesContentJSONString: [String] = []
    let userData = UserManager.shared
    
    // doing
//    func updateFollower(otherUserData: User) {
//        let firestoreManager = FirestoreManager.shared
//        let ref = FirestoreEndpoint.users.ref
//        
//        var otherUserFollowing = otherUserData.following
//        
//        if otherUserFollowing.contains(userData.id) {
//            otherUserFollowing.append(userData.id)
//        } else {
//            if let index = otherUserFollowing.firstIndex(of: userData.id) {
//                userData.savePosts.remove(at: index)
//            }
//        }
//        
//        firestoreManager.updateDocument(data: [UserProperty.followers.rawValue: otherUserFollowers], collection: ref, docID: docID)
//    }
    
    func getMyPosts(postIDs: [String], completion: @escaping() -> Void) async {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.posts.ref
        
        self.posts = []
        self.images = []
        self.contentJSONString = []
        self.myPostsSizes = []
        
        // 一次只能 30 筆，要改
        let posts: [Post] = await firestoreManager.getMultipleDocument(collection: ref, docIDs: postIDs)
        self.posts = posts
        
        for post in posts {
            let url = post.imageUrl
            
            self.contentJSONString.append(post.content)
            
            let cgWidth = CGFloat(post.imageWidth)
            let cgHeight = CGFloat(post.imageHeight)
            
            self.myPostsSizes.append(CGSize(width: cgWidth, height: cgHeight))
        }
        completion()
    }
    
    func getMySaves(savesIDs: [String], completion: @escaping() -> Void) async {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.posts.ref
        
        self.saves = []
        // self.images = []
        self.savesContentJSONString = []
        self.mySavesSizes = []
        
        let saves: [Post] = await firestoreManager.getMultipleDocument(collection: ref, docIDs: savesIDs)
        self.saves = saves
        
        for save in saves {
            let url = save.imageUrl
            
            self.savesContentJSONString.append(save.content)
            
            let cgWidth = CGFloat(save.imageWidth)
            let cgHeight = CGFloat(save.imageHeight)
            
            self.mySavesSizes.append(CGSize(width: cgWidth, height: cgHeight))
        }
        completion()
    }
}
