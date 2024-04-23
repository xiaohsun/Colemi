//
//  PostDetailViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/17/24.
//

import Foundation
import FirebaseFirestore

class PostDetailViewModel {
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            comments = post.comments
        }
    }
    var comments: [Comment] = []
    let userData = UserManager.shared
    
    func decodeContent(jsonString: String, completion: @escaping (Content) -> Void) {
        let cleanedString = jsonString.replacingOccurrences(of: "\\", with: "")
        
        guard let jsonData = cleanedString.data(using: .utf8) else {
            print("Can't transform String to jsonData")
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(Content.self, from: jsonData)
            completion(decodedData)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func updateSavedPosts(savedPostsArray: [String], postID: String, docID: String) async {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.users.ref
        
        firestoreManager.updateDocument(data: [UserProperty.savedPosts.rawValue: savedPostsArray], collection: ref, docID: docID)
    }
    
    func updateComments(commentText: String) {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.posts.ref
        
        guard let post = post else { return }

        comments.append(Comment(id: "\(UUID().uuidString)\(Date().timeIntervalSince1970)", postID: post.id, userID: userData.id, avatarURL: userData.avatarPhoto, userName: userData.name, body: commentText, createdTime: "\(FieldValue.serverTimestamp())"))
        
        firestoreManager.updateDocument(data: [PostProperty.comments.rawValue: comments], collection: ref, docID: post.id)
    }
}
