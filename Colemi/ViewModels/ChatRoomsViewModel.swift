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
        
            await firestoreManager.getSpecificDocumentRealtime(collection: ref, docID: userData.id) { (userData: User?) in
                DispatchQueue.main.async {
                    if let userData = userData {
                        self.userData.chatRooms = userData.chatRooms
                        completion()
                    }
                }
            }
        }
    }
    
    func createDetailedChatRoom() {
        let docRef = firestoreManager.newDocument(of: FirestoreEndpoint.chatRooms.ref)
        let detailedChatRoom = DetailedChatRoom(id: docRef.documentID, userOneID: FakeUserData.shared.userOneID, userTwoID: FakeUserData.shared.userTwoID, messages: [])
        
        firestoreManager.setData(detailedChatRoom, at: docRef)
        
        Task {
            await updateUsersSimpleChatRoom(detailedChatRoomID: docRef.documentID)
        }
    }
    
    private func updateUsersSimpleChatRoom(detailedChatRoomID: String) async {
        let ref = FirestoreEndpoint.users.ref
        
        guard let myUserData: User? = await firestoreManager.getSpecificDocument(collection: ref, docID: FakeUserData.shared.userOneID), var simpleChatRoomArray = myUserData?.chatRooms else { return }
        
        simpleChatRoomArray.append(SimpleChatRoom(id: detailedChatRoomID, receiverAvatarURL: "", latestMessage: "", latestMessageSender: userData.id, latestMessageType: 0, receiverID: FakeUserData.shared.userTwoID, receiverName: "柏勳二號", latestMessageTime: Timestamp()))
        
        firestoreManager.updateDocument(data: [ UserProperty.chatRooms.rawValue: simpleChatRoomArray], collection: ref, docID: FakeUserData.shared.userOneID)
        
        guard let otherUserData: User? = await firestoreManager.getSpecificDocument(collection: ref, docID: FakeUserData.shared.userTwoID), var simpleChatRoomArray = otherUserData?.chatRooms else { return }
        
        simpleChatRoomArray.append(SimpleChatRoom(id: detailedChatRoomID, receiverAvatarURL: "", latestMessage: "", latestMessageSender: userData.id, latestMessageType: 0, receiverID: FakeUserData.shared.userOneID, receiverName: "柏勳一號", latestMessageTime: Timestamp()))
        
        firestoreManager.updateDocument(data: [ UserProperty.chatRooms.rawValue: simpleChatRoomArray], collection: ref, docID: FakeUserData.shared.userTwoID)
    }
    
    
}
