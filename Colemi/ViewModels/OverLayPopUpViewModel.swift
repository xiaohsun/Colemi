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
    var otherUserbeBlocked: [String] = []
    
    func updateBlockingData() async {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.users.ref
        
        var myBlocking = userData.blocking
        myBlocking.append(otherUserID)
        firestoreManager.updateDocument(data: [UserProperty.blocking.rawValue: myBlocking], collection: ref, docID: userData.id)
        userData.blocking = myBlocking
        
        otherUserbeBlocked.append(userData.id)
        firestoreManager.updateDocument(data: [UserProperty.beBlocked.rawValue: otherUserbeBlocked], collection: ref, docID: otherUserID)
    }
}
