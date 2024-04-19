//
//  FirestoreManager.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum FirestoreEndpoint {
    case users
    case posts
    case chatRooms
    case reports
    case messages
    
    var ref: CollectionReference {
        let firestore = Firestore.firestore()
        
        switch self {
        case .users:
            return firestore.collection("users")
        case .posts:
            return firestore.collection("posts")
        case .chatRooms:
            return firestore.collection("chatRooms")
        case .reports:
            return firestore.collection("reports")
        case .messages:
            return firestore.collection("messages")
        }
    }
}

class FirestoreManager {
    static let shared = FirestoreManager()
    
    func getDocuments<T: Decodable>(_ query: Query, completion: @escaping ([T]) -> Void) {
        query.getDocuments {[weak self] snapshot, error in
            guard let `self` = self else { return }
            completion(self.parseDocuments(snapshot: snapshot, error: error))
        }
    }
    
    func getSpecificDocument<T: Codable>(collection: CollectionReference, docID: String) async -> T? {
        
        let docRef = collection.document(docID)
        
        do {
            let document = try await docRef.getDocument()
            if document.exists {
                if let data = document.data() {
                    let decodedData = try Firestore.Decoder().decode(T.self, from: data)
                    return decodedData
                } else {
                    print("Document data is empty")
                    return nil
                }
            } else {
                print("Document does not exist")
                return nil
            }
        } catch {
            print("Error getting document: \(error)")
            return nil
        }
    }
    
    func updateDocument<T>(data: [String: T], collection: CollectionReference, docID: String) {
        collection.document(docID).updateData(data)
    }
    
    func setData<T: Encodable>(_ data: T, at docRef: DocumentReference) {
        do {
            try docRef.setData(from: data)
        } catch {
            print("DEBUG: Error encoding \(data.self) data -", error.localizedDescription)
        }
    }
    
    func newDocument(of collection: CollectionReference) -> DocumentReference {
        collection.document()
    }
    
    private func parseDocuments<T: Decodable>(snapshot: QuerySnapshot?, error: Error?) -> [T] {
        guard let snapshot = snapshot else {
            let errorMessage = error?.localizedDescription ?? ""
            print("DEBUG: Error fetching snapshot -", errorMessage)
            return []
        }
        
        var models: [T] = []
        snapshot.documents.forEach { document in
            do {
                let item = try document.data(as: T.self)
                models.append(item)
            } catch {
                print("DEBUG: Error decoding \(T.self) data -", error.localizedDescription)
            }
        }
        return models
    }
}
