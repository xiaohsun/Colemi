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
    
//    func chatRoomExist() async -> Bool {
//        guard let otherUserData = otherUserData else { return false }
//        
//        let ref = FirestoreEndpoint.chatRooms.ref
//        
//        var detailedChatroom1 = ref.whereField(DetailedChatRoomProperty.userOneID.rawValue, isEqualTo: userData.id).whereField(DetailedChatRoomProperty.userTwoID.rawValue, isEqualTo: otherUserData.id)
//        
//        var detailedChatroom2 = ref.whereField(DetailedChatRoomProperty.userTwoID.rawValue, isEqualTo: userData.id).whereField(DetailedChatRoomProperty.userOneID.rawValue, isEqualTo: otherUserData.id)
//        
//        var detailRoom1Data: DetailedChatRoom? = await firestoreManager.getIsEqualToNotInDocument(query: detailedChatroom1)
//        var detailRoom2Data: DetailedChatRoom? = await firestoreManager.getIsEqualToNotInDocument(query: detailedChatroom2)
//        
//        
//        if detailRoom1Data == nil && detailRoom2Data == nil {
//            return false
//        } else {
//            return true
//        }
//    }
    
    func getUserData(completion: @escaping() -> Void) async {
        let ref = FirestoreEndpoint.users.ref
        let userData: User? = await firestoreManager.getSpecificDocument(collection: ref, docID: userData.id)
        
        if let userData = userData {
            self.userData.chatRooms = userData.chatRooms
        }
        completion()
    }
    
    func createDetailedChatRoom() {
        // 先要打一次資料確定自己沒有這個人
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
        
        mySimpleChatRoomArray.append(SimpleChatRoom(id: detailedChatRoomID, receiverAvatarURL: otherUserData.avatarPhoto, latestMessage: "", latestMessageSender: userData.id, latestMessageType: 0, receiverID: otherUserData.id, receiverName: otherUserData.name, latestMessageTime: Timestamp()))
        
        firestoreManager.updateDocument(data: [UserProperty.chatRooms.rawValue: mySimpleChatRoomArray], collection: ref, docID: userData.id)
        
        userData.chatRooms = mySimpleChatRoomArray
        
        var othersSimpleChatRoomArray = otherUserData.chatRooms
        
        othersSimpleChatRoomArray.append(SimpleChatRoom(id: detailedChatRoomID, receiverAvatarURL: userData.avatarPhoto, latestMessage: "", latestMessageSender: userData.id, latestMessageType: 0, receiverID: userData.id, receiverName: userData.name, latestMessageTime: Timestamp()))
        
        firestoreManager.updateDocument(data: [UserProperty.chatRooms.rawValue: othersSimpleChatRoomArray], collection: ref, docID: otherUserData.id)
    }
}
