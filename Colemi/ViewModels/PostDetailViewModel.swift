//
//  PostDetailViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/17/24.
//

import Foundation
import FirebaseFirestore
import Combine

class PostDetailViewModel {
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            comments = post.comments
            tag = post.tag
        }
    }
    
    var comments: [Comment] = []
    let userData = UserManager.shared
    let firestoreManager = FirestoreManager.shared
    // var authorName: String = ""
    var authorData: User?
    var authorID = ""
    let authorName = CurrentValueSubject<String, Never>("")
    
    var tag = ""
    var contentJSONString = ""
    var postID = ""
    var imageUrl = ""
    var content: Content?
    
    func decodeContent() {
        let cleanedString = contentJSONString.replacingOccurrences(of: "\\", with: "")
        
        guard let jsonData = cleanedString.data(using: .utf8) else {
            print("Can't transform String to jsonData")
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(Content.self, from: jsonData)
            self.content = decodedData
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func updateSavedPosts(docID: String) async {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.users.ref
        
        if userData.savedPosts.contains(postID) {
            userData.savedPosts.removeAll { $0 == postID }
        } else {
            userData.savedPosts.append(postID)
        }
        
        firestoreManager.updateDocument(data: [UserProperty.savedPosts.rawValue: userData.savedPosts], collection: ref, docID: docID)
    }
    
    func updateComments(commentText: String) {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.posts.ref
        
        guard let post = post else { return }

        comments.append(Comment(id: "\(UUID().uuidString)\(Date().timeIntervalSince1970)", postID: post.id, userID: userData.id, avatarURL: userData.avatarPhoto, userName: userData.name, body: commentText, createdTime: "\(FieldValue.serverTimestamp())"))
        
        firestoreManager.updateDocument(data: [PostProperty.comments.rawValue: comments], collection: ref, docID: post.id)
    }
    
    func getPostData() {
        let ref = FirestoreEndpoint.posts.ref
        guard let post = post else { return }
        
        Task {
            let postData: Post? = await firestoreManager.getSpecificDocument(collection: ref, docID: post.id)
            
            if let postData = postData {
                self.post = postData
                self.getAuthorData()
            }
        }
    }
    
    private func getAuthorData() {
        let ref = FirestoreEndpoint.users.ref
        guard let post = post else { return }
        
        Task {
            let userData: User? = await firestoreManager.getSpecificDocument(collection: ref, docID: post.authorId)
            
            if let userData = userData {
                self.authorData = userData
                self.authorName.value = userData.name
            }
        }
    }
}
