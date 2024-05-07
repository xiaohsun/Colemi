//
//  ChatCellViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/4/24.
//

import Foundation
import FirebaseFirestore

class ChatCellViewModel {
    let firestoreManager = FirestoreManager.shared
    let userData = UserManager.shared
    var otherUserData: User?
    var chatRoomID = ""
    
    func createDetailedChatRoom() {
        guard let otherUserData = otherUserData else { return }
        
        let docRef = firestoreManager.newDocument(of: FirestoreEndpoint.chatRooms.ref)
        let detailedChatRoom = DetailedChatRoom(id: docRef.documentID, userOneID: userData.id, userTwoID: otherUserData.id, messages: [])
        
        firestoreManager.setData(detailedChatRoom, at: docRef)
        chatRoomID = docRef.documentID
        
        Task {
            await updateUsersSimpleChatRoom(detailedChatRoomID: docRef.documentID)
        }
    }
    
    private func updateUsersSimpleChatRoom(detailedChatRoomID: String) async {
        guard let otherUserData = otherUserData else { return }
        
        let ref = FirestoreEndpoint.users.ref
        
        var mySimpleChatRoomArray = userData.chatRooms
        
        mySimpleChatRoomArray.append(SimpleChatRoom(id: detailedChatRoomID, receiverAvatarURL: otherUserData.avatarPhoto, latestMessage: "", receiverID: otherUserData.id, receiverName: otherUserData.name, latestMessageTime: Timestamp()))
        
        firestoreManager.updateDocument(data: [UserProperty.chatRooms.rawValue: mySimpleChatRoomArray], collection: ref, docID: userData.id)
        
        var othersSimpleChatRoomArray = otherUserData.chatRooms
        
        othersSimpleChatRoomArray.append(SimpleChatRoom(id: detailedChatRoomID, receiverAvatarURL: userData.avatarPhoto, latestMessage: "", receiverID: userData.id, receiverName: userData.name, latestMessageTime: Timestamp()))
        
        firestoreManager.updateDocument(data: [UserProperty.chatRooms.rawValue: othersSimpleChatRoomArray], collection: ref, docID: otherUserData.id)
    }
}
