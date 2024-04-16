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
    
    var posts: [PostModel] = []
    
    func readData() {
        Firestore.firestore().collection("posts").order(by: "createdTime", descending: true).getDocuments { querySnapshot, error in
            
            self.posts = []
            
            if let e = error {
                print("There was an issue saving data to firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let authorId = data[P.authorId.rawValue] as? String,
                           let color = data[P.color.rawValue] as? String,
                           let colorSimularity = data[P.colorSimularity.rawValue] as? String,
                           let content = data[P.content.rawValue] as? String,
                           let createdTime = data[P.createdTime.rawValue] as? Timestamp,
                           let id = data[P.id.rawValue] as? String,
                           let reports = data[P.reports.rawValue] as? [String],
                           let totalSaved = data[P.totalSaved.rawValue] as? [String],
                           let type = data[P.type.rawValue] as? Int {
                            
                            DispatchQueue.main.async {
                                self.posts.append(PostModel(authorId: authorId, color: color, colorSimularity: colorSimularity, content: content, createdTime: createdTime, id: id, reports: reports, totalSaved: totalSaved, type: type))
                            }
                        }
                    }
                }
            }
        }
    }
}
