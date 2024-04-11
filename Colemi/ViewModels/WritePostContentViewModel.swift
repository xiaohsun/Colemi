//
//  WritePostContentViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/11/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class WritePostContentViewModel {
    func addData(authorId: String, content: String, type: Int, color: String, tags: [String]) {
        
        let posts = Firestore.firestore().collection("posts")
        let document = posts.document()
        let data: [String: Any] = [
            "authorId": "1213123",
            "id": document.documentID,
            "content": content,
            "type": 0,
            "color": "#123456",
            "createdTime": FieldValue.serverTimestamp(),
            "colorSimularity": 0.0,
            "totalSaved": [] as [String] ,
            "reports":  [] as [String]
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
        
        print(contentJSON)
        
        return contentJSON
    }
}
