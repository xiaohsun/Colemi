//
//  WritePostContentViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/11/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class WritePostContentViewModel {
    
    weak var delegate: WritePostContentViewModelDelegate?
    var postDocID: String = ""
    let userData = UserManager.shared
    
    func addData(authorId: String, content: String, type: Int, color: String, tag: String, imageUrl: String, imageHeight: Double, imageWidth: Double) {
        
        let posts = Firestore.firestore().collection("posts")
        let document = posts.document()
        let data: [String: Any] = [
            PostProperty.authorId.rawValue: authorId,
            PostProperty.id.rawValue: document.documentID,
            PostProperty.content.rawValue: content,
            PostProperty.type.rawValue: 0,
            PostProperty.color.rawValue: color,
            PostProperty.createdTime.rawValue: FieldValue.serverTimestamp(),
            PostProperty.totalSaved.rawValue: [] as [String],
            PostProperty.reports.rawValue: [] as [String],
            PostProperty.imageUrl.rawValue: imageUrl,
            PostProperty.imageHeight.rawValue: imageHeight,
            PostProperty.imageWidth.rawValue: imageWidth,
            PostProperty.comments.rawValue: [],
            PostProperty.colorPoints.rawValue: 0,
            PostProperty.tag.rawValue: tag
        ]
        document.setData(data)
        postDocID = document.documentID
        
        Task {
            await self.updateData(postID: postDocID)
        }
    }
    
  
    func updateData(postID: String) async {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.users.ref
        
        userData.posts.append(postID)
        userData.postToday = postID
        
        let updateData: [String: Any] = [
            UserProperty.posts.rawValue: userData.posts,
            UserProperty.postToday.rawValue: postID
        ]
        
        firestoreManager.updateMutipleDocument(data: updateData, collection: ref, docID: userData.id)
    }
    
    func makeContentJson(content: Content) -> String {
        var contentJSON = ""
        
        let contentDic: [String: Any] = [
            "authorName": content.authorName,
            "title": content.title,
            "imgURL": content.imgURL,
            "description": content.description
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: contentDic, options: [.prettyPrinted, .withoutEscapingSlashes])
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                contentJSON = jsonString
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return contentJSON
    }
    
    // 有兩個地方用到，要改成可複用
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
                    self.delegate?.addDataToFireBase(downloadURL.absoluteString, imageSize: imageSize)
                } else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
}

protocol WritePostContentViewModelDelegate: AnyObject {
    func addDataToFireBase(_ imageUrl: String, imageSize: CGSize)
}
