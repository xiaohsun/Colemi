//
//  PostDetailViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/17/24.
//

import Foundation

class PostDetailViewModel {
    
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
    
    // doing
    func updateSavedPosts(savedPostsArray: [String], postID: String, docID: String) async {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.users.ref
        
        firestoreManager.updateDocument(data: [UserProperty.savePosts.rawValue: savedPostsArray], collection: ref, docID: docID)
    }
}
