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
    
    func addData(authorId: String, content: String, type: Int, color: String, colorSimularity: String, tags: [String]) {
        
        let posts = Firestore.firestore().collection("posts")
        let document = posts.document()
        let data: [String: Any] = [
            P.authorId.rawValue: "1213123",
            P.id.rawValue: document.documentID,
            P.content.rawValue: content,
            P.type.rawValue: 0,
            P.color.rawValue: color,
            P.createdTime.rawValue: FieldValue.serverTimestamp(),
            P.colorSimularity.rawValue: colorSimularity,
            P.totalSaved.rawValue: [] as [String] ,
            P.reports.rawValue:  [] as [String]
        ]
        document.setData(data)
    }
    
    func makeContentJson( authorName: String, title: String, imgURL: String, description: String) -> String {
        var contentJSON = ""
        
        let content: [String: Any] = [
            "authorName": "柏勳",
            "title": title,
            "imgURL": imgURL,
            "description": description
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: content, options: [.prettyPrinted, .withoutEscapingSlashes])
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                contentJSON = jsonString
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return contentJSON
    }
    
    func uploadImgToFirebase(imageData: Data) {
        
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
            
            storageRef.downloadURL { (downloadURL, error) in
                if let downloadURL = downloadURL {
                    print("Image uploaded to: \(downloadURL.absoluteString)")
                    self.delegate?.addDataToFireBase(downloadURL.absoluteString)
                } else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
}

protocol WritePostContentViewModelDelegate: AnyObject {
    func addDataToFireBase(_ imageUrl: String)
}
