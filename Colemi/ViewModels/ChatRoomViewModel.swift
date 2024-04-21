//
//  ChatRoomViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/19/24.
//

import Foundation
import FirebaseFirestore

class ChatRoomViewModel {
    
    weak var delegate: ChatRoomViewModelDelegate?
    let firestoreManager = FirestoreManager.shared
    
    var chatRoomID: String = "" {
        didSet {
            getDetailedChatRoomData(chatRoomID: chatRoomID)
        }
    }
    
    var chatRoomData: DetailedChatRoom?
    var messages: [Message] = []
    
    func getDetailedChatRoomData(chatRoomID: String) {
        Task {
            let firestoreManager = FirestoreManager.shared
            let ref = FirestoreEndpoint.users.ref
            
            let chatRoomData: DetailedChatRoom? = await firestoreManager.getSpecificDocument(collection: ref, docID: chatRoomID)
            
            if let chatRoomData = chatRoomData {
                self.messages = messages
                self.chatRoomData = chatRoomData
                delegate?.updateTableView()
            }
        }
    }
    
    
    // 更新 Chatroom 內的 messages
    // 拿到原本的然後 append 後加回去
    
    // 更新 user chatroom 的時間
    // remove 再 append，就可以確保時間在最前面
    
    // 或是不管時間順序，去修改原本的時間，不刪除也不新增 simpleChatRoom
    // 但是在 chatsroom 拿 array 下來的時候，要依照時間順序來排序 sort
    
    // 用 chatroom id 找
    
    // 必須先有 user
    // doing
    func updateUsersSimpleChatRoom(detailedChatRoomID: String, latestMessage: String) async {
        let ref = FirestoreEndpoint.users.ref
        
        guard let chatRoomData = chatRoomData, let myUserData: User? = await firestoreManager.getSpecificDocument(collection: ref, docID: chatRoomData.userOneID), var simpleChatRoomArray = myUserData?.chatRooms else { return }
        
        if let index = simpleChatRoomArray.firstIndex(where: { $0.id == chatRoomID }) {
            simpleChatRoomArray.append(SimpleChatRoom(id: chatRoomID, receiverAvatarURL: simpleChatRoomArray[index].receiverAvatarURL, latestMessage: latestMessage, receiverID: simpleChatRoomArray[index].receiverID, receiverName: simpleChatRoomArray[index].receiverName, latestMessageTime: Timestamp()))
            
            simpleChatRoomArray.remove(at: index)
            
            if let myUserData = myUserData {
                firestoreManager.updateDocument(data: [UserProperty.chatRooms.rawValue: simpleChatRoomArray], collection: ref, docID: myUserData.id)
            }
        }
        
        guard let otherUserData: User? = await firestoreManager.getSpecificDocument(collection: ref, docID: chatRoomData.userOneID), var simpleChatRoomArray = otherUserData?.chatRooms else { return }
        
        if let index = simpleChatRoomArray.firstIndex(where: { $0.id == chatRoomID }) {
            simpleChatRoomArray.append(SimpleChatRoom(id: chatRoomID, receiverAvatarURL: simpleChatRoomArray[index].receiverAvatarURL, latestMessage: latestMessage, receiverID: simpleChatRoomArray[index].receiverID, receiverName: simpleChatRoomArray[index].receiverName, latestMessageTime: Timestamp()))
            
            simpleChatRoomArray.remove(at: index)
            
            if let otherUserData = otherUserData {
                firestoreManager.updateDocument(data: [UserProperty.chatRooms.rawValue: simpleChatRoomArray], collection: ref, docID: otherUserData.id)
            }
        }
    }
}

protocol ChatRoomViewModelDelegate: AnyObject {
    func updateTableView()
}
