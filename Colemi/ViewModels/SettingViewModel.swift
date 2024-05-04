//
//  SettingViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/4/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class SettingViewModel {
    
    let userData = UserManager.shared
    
    func uploadImgToFirebase(imageData: Data, imageSize: CGSize) {
       
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        
        storageRef.putData(imageData, metadata: nil) { (_, error) in
            
            storageRef.downloadURL { (downloadURL, error) in
                if let downloadURL = downloadURL {
                    print("Image uploaded to: \(downloadURL.absoluteString)")
                    self.updateUserData(url: downloadURL.absoluteString, docID: self.userData.id)
                } else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    func updateUserData(url: String, docID: String) {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.users.ref
        
        firestoreManager.updateDocument(data: [UserProperty.avatarPhoto.rawValue: url], collection: ref, docID: docID)
        
        userData.avatarPhoto = url
    }
}
