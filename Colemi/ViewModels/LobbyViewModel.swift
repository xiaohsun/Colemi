//
//  LobbyViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/12/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import Kingfisher

class LobbyViewModel {
    
    var posts: [PostModel] = []
    var images: [UIImage] = []
    
    func readData(completion: @escaping () -> Void) {
        Firestore.firestore().collection("posts").order(by: "createdTime", descending: true).getDocuments { querySnapshot, error in
            
            self.posts = []
            
            if let e = error {
                print("There was an issue saving data to firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let authorId = data[Post.authorId.rawValue] as? String,
                           let color = data[Post.color.rawValue] as? String,
                           let colorSimularity = data[Post.colorSimularity.rawValue] as? String,
                           let content = data[Post.content.rawValue] as? String,
                           let createdTime = data[Post.createdTime.rawValue] as? Timestamp,
                           let id = data[Post.id.rawValue] as? String,
                           let reports = data[Post.reports.rawValue] as? [String],
                           let totalSaved = data[Post.totalSaved.rawValue] as? [String],
                           let type = data[Post.type.rawValue] as? Int,
                           let imageUrl = data[Post.imageUrl.rawValue] as? String {
                            
                            self.posts.append(PostModel(authorId: authorId, color: color, colorSimularity: colorSimularity, content: content, createdTime: createdTime, id: id, reports: reports, totalSaved: totalSaved, type: type, imageUrl: imageUrl))
                            
                            var group = DispatchGroup()
                            group.enter()
                            if let url = URL(string: imageUrl) {
                                KingfisherManager.shared.retrieveImage(with: url) { result in
                                    switch result {
                                    case .success(let value):
                                        self.images.append(value.image)
                                        group.leave()
                                        if self.images.count == snapshotDocuments.count {
                                            group.notify(queue: .main) {
                                                completion()
                                            }
                                        }
                                    case .failure(let error):
                                        print("Error: \(error)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func decodeContent(jsonString: String) {
        let cleanedString = jsonString.replacingOccurrences(of: "\\", with: "")
        
        guard let jsonData = cleanedString.data(using: .utf8) else {
            fatalError("無法將 JSON 字符串轉換為 Data")
        }
        
        do {
            let decodedData = try JSONDecoder().decode(Content.self, from: jsonData)
            
            print("imgURL: \(decodedData.imgURL)")
            print("title: \(decodedData.title)")
            print("description: \(decodedData.description)")
            print("authorName: \(decodedData.authorName)")
        } catch {
            print("解析 JSON 失敗: \(error)")
        }
    }
}

struct Content: Codable {
    let imgURL: String
    let title, description, authorName: String
}
