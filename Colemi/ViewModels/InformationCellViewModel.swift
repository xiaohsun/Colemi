//
//  InformationCellViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/4/24.
//

import Foundation
import FirebaseFirestore

class InformationCellViewModel {
    
    var userData = UserManager.shared
    var otherUserData: User? {
        didSet {
            otherUserFollowers = otherUserData?.followers
        }
    }
    
    var otherUserFollowers: [String]?
    
    func updateFollower(completion: @escaping ([String], Bool) -> Void ) {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.users.ref
        
        var myUserFollowing = userData.following
        var isFollowing = false
        
        guard var otherUserFollowers = otherUserFollowers , let otherUserData = otherUserData else { return }
        
        if !otherUserFollowers.contains(userData.id) {
            otherUserFollowers.append(userData.id)
            myUserFollowing.append(otherUserData.id)
            isFollowing = true
            
        } else {
            if let index = otherUserFollowers.firstIndex(of: userData.id) {
                otherUserFollowers.remove(at: index)
            }
            
            if let index = myUserFollowing.firstIndex(of: otherUserData.id) {
                myUserFollowing.remove(at: index)
            }
        }
        
        userData.following = myUserFollowing
        
        firestoreManager.updateDocument(data: [UserProperty.followers.rawValue: otherUserFollowers], collection: ref, docID: otherUserData.id)
        firestoreManager.updateDocument(data: [UserProperty.following.rawValue: myUserFollowing], collection: ref, docID: userData.id)
        
        self.otherUserFollowers = otherUserFollowers
        
        completion(otherUserFollowers, isFollowing)
    }
    
    func updateUserDescription(text: String) {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.users.ref
        
        userData.description = text
        
        firestoreManager.updateDocument(data: [UserProperty.description.rawValue: text], collection: ref, docID: userData.id)
    }
}
