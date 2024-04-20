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
    
    var posts: [Post] = []
    var images: [UIImage] = []
    var contentJSONString: [String] = []
    let userManager = UserManager.shared
    
    func createUser() {
        let firestoreManager = FirestoreManager.shared
        let docRef = firestoreManager.newDocument(of: FirestoreEndpoint.users.ref)
        let user = User(id: docRef.documentID, 
                        name: "柏勳",
                        posts: [],
                        likes: [],
                        avatarPhoto: "",
                        friends: [],
                        description: "",
                        savePosts: [],
                        signUpTime: Timestamp(),
                        lastestLoginTime: Timestamp(),
                        colorToday: "",
                        chatRooms: [],
                        followers: [],
                        following: [])
        
        firestoreManager.setData(user, at: docRef)
    }
    
    func loginUserOne(completion: @escaping (User?) -> Void) async {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.users.ref
        let userData: User? = await firestoreManager.getSpecificDocument(collection: ref, docID: "RUrCBxssACOTrwSOBJ2n")
        completion(userData)
//        let docRef = ref.document("uEXEtoFSGINxrlEDUypP")
//        
//        do {
//            let document = try docRef.getDocument()
//            if document.exists {
//                if let data = document.data() {
//                    let decodedData = try Firestore.Decoder().decode(User.self, from: data)
//                    completion(decodedData)
//                } else {
//                    print("Document data is empty")
//                }
//            }
//        } catch {
//            print("Error getting document: \(error)")
//        }
    }
    
    func loginUserTwo(completion: @escaping (User?) -> Void) async {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.users.ref
        let userData: User? = await firestoreManager.getSpecificDocument(collection: ref, docID: "dT5NOxCPAgJEiEYjKUuu")
        completion(userData)
    }
    
    func readData(completion: @escaping () -> Void) {
        Firestore.firestore().collection("posts").order(by: "createdTime", descending: true).getDocuments { querySnapshot, error in
            
            self.posts = []
            self.images = []
            self.contentJSONString = []
            
            if let e = error {
                print("There was an issue saving data to firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let authorId = data[PostProperty.authorId.rawValue] as? String,
                           let color = data[PostProperty.color.rawValue] as? String,
                           let colorSimularity = data[PostProperty.colorSimularity.rawValue] as? String,
                           let content = data[PostProperty.content.rawValue] as? String,
                           let createdTime = data[PostProperty.createdTime.rawValue] as? Timestamp,
                           let id = data[PostProperty.id.rawValue] as? String,
                           let reports = data[PostProperty.reports.rawValue] as? [String],
                           let totalSaved = data[PostProperty.totalSaved.rawValue] as? [String],
                           let type = data[PostProperty.type.rawValue] as? Int,
                           let imageUrl = data[PostProperty.imageUrl.rawValue] as? String {
                            
                            self.contentJSONString.append(content)
                            
                            self.posts.append(Post(authorId: authorId, color: color, colorSimularity: colorSimularity, content: content, createdTime: createdTime, id: id, reports: reports, totalSaved: totalSaved, type: type, imageUrl: imageUrl))
                            
                            let group = DispatchGroup()
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
}
