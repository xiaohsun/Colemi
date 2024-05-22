//
//  LobbyViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/12/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import Kingfisher

class LobbyViewModel {
    
    var posts: [Post] = []
    var images: [UIImage] = []
    var contentJSONString: [String] = []
    var sizes: [CGSize] = []
    var userManager = UserManager.shared
    
    func readData(completion: @escaping () -> Void) {
        let ref = FirestoreEndpoint.posts.ref
        let query = ref.order(by: "createdTime", descending: true)
        let firestoreManager = FirestoreManager.shared
        
        self.posts = []
        self.contentJSONString = []
        self.sizes = []
        
        firestoreManager.getDocuments(query) { [weak self] (posts: [Post]) in
            guard let `self` = self else { return }
            self.posts = posts
            
            for post in posts {
                
                let cgWidth = CGFloat(post.imageWidth)
                let cgHeight = CGFloat(post.imageHeight)
                
                self.sizes.append(CGSize(width: cgWidth, height: cgHeight))
                self.contentJSONString.append(post.content)
            }
            completion()
        }
    }
    
    func getSpecificPosts(colorCode: String, completion: @escaping() -> Void) async {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.posts.ref
        
        self.posts = []
        self.contentJSONString = []
        self.sizes = []
        
        let posts: [Post] = await firestoreManager.getMultipleEqualToDocuments(collection: ref, field: "color", value: colorCode)
        
        if userManager.blocking.isEmpty {
            self.posts = posts
            
            for post in posts {
                let cgWidth = CGFloat(post.imageWidth)
                let cgHeight = CGFloat(post.imageHeight)
                
                self.sizes.append(CGSize(width: cgWidth, height: cgHeight))
                self.contentJSONString.append(post.content)
            }
        } else {
            for post in posts {
                for block in userManager.blocking {
                    if post.authorId != block {
                        self.posts.append(post)
                        let cgWidth = CGFloat(post.imageWidth)
                        let cgHeight = CGFloat(post.imageHeight)
                        
                        self.sizes.append(CGSize(width: cgWidth, height: cgHeight))
                        self.contentJSONString.append(post.content)
                    }
                }
            }
        }
        completion()
    }
    
    func getNotInPosts(completion: @escaping() -> Void) async {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.posts.ref
        
        self.posts = []
        self.contentJSONString = []
        self.sizes = []
        
        let posts: [Post] = await firestoreManager.getMultipleNotInDocument(field: "authorId", collection: ref, docIDs: userManager.blocking)
        
        self.posts = posts
        
        for post in posts {
            
            let cgWidth = CGFloat(post.imageWidth)
            let cgHeight = CGFloat(post.imageHeight)
            
            self.sizes.append(CGSize(width: cgWidth, height: cgHeight))
            self.contentJSONString.append(post.content)
        }
        
        completion()
    }
}
