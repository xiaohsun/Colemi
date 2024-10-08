//
//  ChatRoomViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/19/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class ChatRoomViewModel {
    
    weak var delegate: ChatRoomViewModelDelegate?
    let firestoreManager = FirestoreManager.shared
    var otherUserName = ""
    var otherUserAvatarImage: UIImage?
    var timestamp: Timestamp?
    let userData = UserManager.shared
    var imageData: Data?
    var imageSize: CGSize?
    
    var chatRoomID: String = ""
    var chatRoomData: DetailedChatRoom?
    var messages: [Message] = []
    
    func getDetailedChatRoomDataRealTime(chatRoomID: String) {
        Task {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.chatRooms.ref
        
            await firestoreManager.getSpecificDocumentRealtime(collection: ref, docID: chatRoomID) { [weak self] (chatRoomData: DetailedChatRoom?) in
                guard let self else { return }
                
                DispatchQueue.main.async {
                    if let chatRoomData = chatRoomData {
                        self.messages = chatRoomData.messages
                        self.chatRoomData = chatRoomData
                        self.delegate?.updateTableView()
                    }
                }
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
    
    func updateUsersSimpleChatRoom(latestMessage: String, type: Int) async {
        let ref = FirestoreEndpoint.users.ref
        
        timestamp = Timestamp()
        
        guard let timestamp = timestamp,
              let chatRoomData = chatRoomData else { return }
        
        var simpleChatRoomArray = userData.chatRooms
        
        if let index = simpleChatRoomArray.firstIndex(where: { $0.id == chatRoomID }) {
            simpleChatRoomArray.append(SimpleChatRoom(id: chatRoomID, receiverAvatarURL: simpleChatRoomArray[index].receiverAvatarURL, latestMessage: latestMessage, latestMessageSender: userData.id, latestMessageType: type, receiverID: simpleChatRoomArray[index].receiverID, receiverName: simpleChatRoomArray[index].receiverName, latestMessageTime: timestamp))
            
            simpleChatRoomArray.remove(at: index)
            
            firestoreManager.updateDocument(data: [UserProperty.chatRooms.rawValue: simpleChatRoomArray], collection: ref, docID: userData.id)
            userData.chatRooms = simpleChatRoomArray
        }
        
        guard let otherUserData: User? = await firestoreManager.getSpecificDocument(collection: ref, docID: chatRoomData.userTwoID),
              var simpleChatRoomArray = otherUserData?.chatRooms 
        else { return }
        
        if let index = simpleChatRoomArray.firstIndex(where: { $0.id == chatRoomID }) {
            simpleChatRoomArray.append(SimpleChatRoom(id: chatRoomID, receiverAvatarURL: simpleChatRoomArray[index].receiverAvatarURL, latestMessage: latestMessage, latestMessageSender: userData.id, latestMessageType: type, receiverID: simpleChatRoomArray[index].receiverID, receiverName: simpleChatRoomArray[index].receiverName, latestMessageTime: timestamp))
            
            simpleChatRoomArray.remove(at: index)
            
            if let otherUserData = otherUserData {
                firestoreManager.updateDocument(data: [UserProperty.chatRooms.rawValue: simpleChatRoomArray], collection: ref, docID: otherUserData.id)
            }
        }
        
        Task {
            await updateDetailedChatRoom(latestMessage: latestMessage, type: type)
        }
    }
    
    private func updateDetailedChatRoom(latestMessage: String, type: Int) async {
        let ref = FirestoreEndpoint.chatRooms.ref
        
        guard let timestamp = timestamp else { return }
        
        messages.append(Message(id: "\(UUID())\(timestamp.seconds)", senderID: userData.id, body: latestMessage, time: timestamp, type: type))
        
        firestoreManager.updateDocument(data: [DetailedChatRoomProperty.messages.rawValue: messages], collection: ref, docID: chatRoomID)
    }
    
    func uploadImgToFirebase(imageData: Data, imageSize: CGSize) {
       
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // 把 size 存在 firestore
            
            storageRef.downloadURL { (downloadURL, error) in
                if let downloadURL = downloadURL {
                    print("Image uploaded to: \(downloadURL.absoluteString)")
                    
                    Task {
                        await self.updateUsersSimpleChatRoom(latestMessage: downloadURL.absoluteString, type: 1)
                    }
                    
                } else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
//    private func addDataToFireBase(_ imageUrl: String, imageSize: CGSize) {
//        let imageHeight = Double(imageSize.height)
//        let imageWidth = Double(imageSize.width)
//        
//        viewModel.addData(authorId: userManager.id, content: content, type: 0, color: userManager.colorToday, colorSimularity: "", tags: ["Cute"], imageUrl: imageUrl, imageHeight: imageHeight, imageWidth: imageWidth)
//        
//        colorSimilarityViewController.selectedImage = selectedImage
//        colorSimilarityViewController.selectedImageURL = imageUrl
//        
//        navigationController?.pushViewController(colorSimilarityViewController, animated: true)
//    }
}

protocol ChatRoomViewModelDelegate: AnyObject {
    func updateTableView()
}
