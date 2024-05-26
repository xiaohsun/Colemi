//
//  ProfileViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/19/24.
//

import UIKit
import Kingfisher
import FirebaseFirestore
import Combine

class ProfileViewModel {
    
    let firestoreManager = FirestoreManager.shared
    var posts: [Post] = []
    var saves: [Post] = []
    var images: [UIImage] = []
    var myPostsSizes: [CGSize] = []
    var mySavesSizes: [CGSize] = []
    var contentJSONString: [String] = []
    var savesContentJSONString: [String] = []
    var userData = UserManager.shared
    var userID = ""
    
    let otherUserData = CurrentValueSubject<User?, Never>(nil)
    
    var otherUserFollowers: [String]?
    
    func getOtherUserData() {
        let ref = FirestoreEndpoint.users.ref
        
        Task {
            let userData: User? = await firestoreManager.getSpecificDocument(collection: ref, docID: userID)
            
            if let userData = userData {
                self.otherUserFollowers = userData.followers
                self.otherUserData.value = userData
            }
        }
    }
    
    func getUserData(completion: @escaping() -> Void) async {
        let ref = FirestoreEndpoint.users.ref
        let userData: User? = await firestoreManager.getSpecificDocument(collection: ref, docID: userData.id)
        
        if let userData = userData {
            self.userData.followers = userData.followers
            self.userData.following = userData.following
        }
        completion()
    }
    
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
