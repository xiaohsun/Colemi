//
//  ProfileViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/19/24.
//

import UIKit
import Kingfisher

class ProfileViewModel {
    
    var posts: [Post] = []
    var images: [UIImage] = []
    var sizes: [CGSize] = []
    var contentJSONString: [String] = []
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
        self.sizes = []
        
        // 一次只能 30 筆，要改
        let posts: [Post] = await firestoreManager.getMultipleDocument(collection: ref, docIDs: postIDs)
        self.posts = posts
        
        for post in posts {
            let url = post.imageUrl
            
            self.contentJSONString.append(post.content)
            
            let cgWidth = CGFloat(post.imageWidth)
            let cgHeight = CGFloat(post.imageHeight)
            
            self.sizes.append(CGSize(width: cgWidth, height: cgHeight))
            
//            let group = DispatchGroup()
//            group.enter()
//            if let url = URL(string: url) {
//                KingfisherManager.shared.retrieveImage(with: url) { result in
//                    switch result {
//                    case .success(let value):
//                        self.images.append(value.image)
//                        group.leave()
//                        if self.images.count == posts.count {
//                            group.notify(queue: .main) {
//                                completion()
//                            }
//                        }
//                    case .failure(let error):
//                        print("Error: \(error)")
//                    }
//                }
//            }
        }
        completion()
    }
    
    func getSaves() {
        
    }
}
