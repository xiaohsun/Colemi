//
//  OverLayPopUpViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/6/24.
//

import Foundation

class OverLayPopUpViewModel {
    let userData = UserManager.shared
    var otherUserID: String = ""
    var beBlocked: [String] = []
    
    func updateBlockingData(savedPostsArray: [String], postID: String, docID: String) async {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.users.ref
        
        firestoreManager.updateDocument(data: [UserProperty.savedPosts.rawValue: savedPostsArray], collection: ref, docID: docID)
    }
}
