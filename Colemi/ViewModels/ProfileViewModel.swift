//
//  ProfileViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/19/24.
//

import UIKit
import Kingfisher
import FirebaseFirestore
// import Combine

class ProfileViewModel {
    
    //    @Published var isShowingPosts: Bool = false
    //    private var cancellables = Set<AnyCancellable>()
    
    let firestoreManager = FirestoreManager.shared
    var posts: [Post] = []
    var saves: [Post] = []
    var images: [UIImage] = []
    var myPostsSizes: [CGSize] = []
    var mySavesSizes: [CGSize] = []
    var contentJSONString: [String] = []
    var savesContentJSONString: [String] = []
    var userData = UserManager.shared
    
    var otherUserData: User? {
        didSet {
            otherUserFollowers = otherUserData?.followers
        }
    }
    var otherUserFollowers: [String]?
    
    //    init() {
    //        $isShowingPosts.sink(receiveValue: { _ in
    //            print("Status Change")
    //        }).store(in: &cancellables)
    //    }
    //
    //    deinit {
    //        cancellables.forEach { $0.cancel() }
    //    }
    
    
//    func updateFollower(otherUserData: User, completion: @escaping ([String]) -> Void ) {
//        let firestoreManager = FirestoreManager.shared
//        let ref = FirestoreEndpoint.users.ref
//        
//        var otherUserFollowers = otherUserData.followers
//        var myUserFollowing = userData.following
//        
//        if !otherUserFollowers.contains(userData.id) {
//            otherUserFollowers.append(userData.id)
//            myUserFollowing.append(otherUserData.id)
//            
//        } else {
//            if let index = otherUserFollowers.firstIndex(of: userData.id) {
//                otherUserFollowers.remove(at: index)
//            }
//            
//            if let index = myUserFollowing.firstIndex(of: otherUserData.id) {
//                myUserFollowing.remove(at: index)
//            }
//        }
//        
//        userData.following = myUserFollowing
//        
//        firestoreManager.updateDocument(data: [UserProperty.followers.rawValue: otherUserFollowers], collection: ref, docID: otherUserData.id)
//        firestoreManager.updateDocument(data: [UserProperty.following.rawValue: myUserFollowing], collection: ref, docID: userData.id)
//        
//        completion(otherUserFollowers)
//    }
    
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
    
//    func updateUserDescription(text: String) {
//        let firestoreManager = FirestoreManager.shared
//        let ref = FirestoreEndpoint.users.ref
//        
//        userData.description = text
//        
//        firestoreManager.updateDocument(data: [ UserProperty.description.rawValue: text], collection: ref, docID: userData.id)
//    }
}
