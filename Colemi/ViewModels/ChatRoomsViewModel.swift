//
//  ChatRoomsViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/21/24.
//

import Foundation
import FirebaseFirestore

class ChatRoomsViewModel {
    
    let firestoreManager = FirestoreManager.shared
    let userData = UserManager.shared
    
    func getSimpleChatRoomDataRealTime(completion: @escaping () -> Void) {
        Task {
            let ref = FirestoreEndpoint.users.ref
        
            await firestoreManager.getSpecificDocumentRealtime(collection: ref, docID: userData.id) { [weak self] (userData: User?) in
                guard let self else { return }
                
                DispatchQueue.main.async {
                    if let userData = userData {
                        self.userData.chatRooms = userData.chatRooms.reversed()
                        completion()
                    } 
                }
            }
        }
    }
}
