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
    
    func addData(authorId: String, content: String, type: Int, color: String, colorSimularity: String, tags: [String], imageUrl: String, imageHeight: Double, imageWidth: Double) {
        
        let posts = Firestore.firestore().collection("posts")
        let document = posts.document()
        let data: [String: Any] = [
            PostProperty.authorId.rawValue: authorId,
            PostProperty.id.rawValue: document.documentID,
            PostProperty.content.rawValue: content,
            PostProperty.type.rawValue: 0,
            PostProperty.color.rawValue: color,
            PostProperty.createdTime.rawValue: FieldValue.serverTimestamp(),
            PostProperty.colorSimularity.rawValue: colorSimularity,
            PostProperty.totalSaved.rawValue: [] as [String],
            PostProperty.reports.rawValue: [] as [String],
            PostProperty.imageUrl.rawValue: imageUrl,
            PostProperty.imageHeight.rawValue: imageHeight,
            PostProperty.imageWidth.rawValue: imageWidth
        ]
        document.setData(data)
        
        // doing
        Task {
            await self.updateData(postID: document.documentID, docID: UserManager.shared.id)
        }
    }
    // doing
    func updateData(postID: String, docID: String) async {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.users.ref
        
        guard let user: User? = await firestoreManager.getSpecificDocument(collection: ref, docID: docID), var postsArray = user?.posts else { return }
        
        postsArray.append(postID)
        
        firestoreManager.updateDocument(data: [ UserProperty.posts.rawValue: postsArray], collection: ref, docID: docID)
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
    
    func uploadImgToFirebase(imageData: Data, imageSize: CGSize) {
        
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
//            print("Failed to convert image to data.")
//            return
//        }
       
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
