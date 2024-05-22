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
    
    func getSpecificDocumentRealtime<T: Codable>(collection: CollectionReference, docID: String, completion: @escaping (T?) -> Void) async {
        let docRef = collection.document(docID)
        
        docRef.addSnapshotListener { documentSnapshot, error in
            do {
                guard let document = documentSnapshot else {
                    return
                }
                guard let data = document.data() else {
                    return
                }
                print("Current data: \(data)")
                
                let decodedData = try Firestore.Decoder().decode(T.self, from: data)
                completion(decodedData)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
    }
    
    // Limitted 30
    func getMultipleDocument<T: Codable>(collection: CollectionReference, docIDs: [String]) async -> [T] {
        
        var documents: [T] = []
        
        if docIDs != [] {
            
            var query: Query?
            
            if collection == FirestoreEndpoint.posts.ref {
                query = collection.whereField(FieldPath.documentID(), in: docIDs).order(by: "createdTime", descending: true)
            } else {
                query = collection.whereField(FieldPath.documentID(), in: docIDs)
            }
            
            do {
                guard let query = query else { return [] }
                let querySnapshots = try await query.getDocuments()
                for doc in querySnapshots.documents {
                    let data = doc.data()
                    if let decodedData = try? Firestore.Decoder().decode(T.self, from: data) {
                        documents.append(decodedData)
                    }
                }
            } catch {
                print("Error fetching documents: \(error)")
            }
            return documents
        }
        
        return documents
    }
    
    func getMultipleEqualToDocuments<T: Codable>(collection: CollectionReference, field: String, value: String) async -> [T] {
        
        var documents: [T] = []
        
        if value != "" {
            
            var query: Query?
            
            query = collection.whereField(field, isEqualTo: value).order(by: "createdTime", descending: true)
            
            do {
                guard let query = query else { return [] }
                let querySnapshots = try await query.getDocuments()
                for doc in querySnapshots.documents {
                    let data = doc.data()
                    if let decodedData = try? Firestore.Decoder().decode(T.self, from: data) {
                        documents.append(decodedData)
                    }
                }
            } catch {
                print("Error fetching documents: \(error)")
            }
            return documents
        }
        
        return documents
    }
    
    func getMultipleNotInDocument<T: Codable>(field: String, collection: CollectionReference, docIDs: [String]) async -> [T] {
        
        var documents: [T] = []
        
        if docIDs != [] {
            
            var query: Query?
            
            if collection == FirestoreEndpoint.posts.ref {
                query = collection.whereField(field, notIn: docIDs).order(by: "createdTime", descending: true)
            } else {
                query = collection.whereField(field, in: docIDs)
            }
            
            do {
                guard let query = query else { return [] }
                let querySnapshots = try await query.getDocuments()
                for doc in querySnapshots.documents {
                    let data = doc.data()
                    if let decodedData = try? Firestore.Decoder().decode(T.self, from: data) {
                        documents.append(decodedData)
                    }
                }
            } catch {
                print("Error fetching documents: \(error)")
            }
            return documents
        }
        
        return documents
    }
    
    func updateDocument<T: Encodable>(data: [String: T], collection: CollectionReference, docID: String) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            guard let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                print("Error: Could not convert data to JSON dictionary")
                return
            }
            collection.document(docID).updateData(jsonDict)
        } catch {
            print("Error encoding data: \(error)")
        }
    }
    
    func updateMutipleDocument(data: [String: Any], collection: CollectionReference, docID: String) {
        collection.document(docID).updateData(data) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func setData<T: Encodable>(_ data: T, at docRef: DocumentReference, completion: ((() -> Void)?) = nil) {
        do {
            try docRef.setData(from: data)
            completion?()
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
