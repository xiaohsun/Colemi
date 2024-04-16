//
//  LobbyViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/12/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class LobbyViewModel {
    
    var posts: [[String: Any]] = []
    
    func readData() {
        Firestore.firestore().collection("posts").order(by: "createdTime", descending: true).getDocuments { querySnapshot, error in
            
            self.posts = []
            
            if let e = error {
                print("There was an issue saving data to firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        DispatchQueue.main.async {
                            self.posts.append(data)
                        }
                    }
                }
            }
        }
    }
}
