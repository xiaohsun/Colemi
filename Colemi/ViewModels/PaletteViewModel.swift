//
//  PaletteViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/7/24.
//

import Foundation

class PaletteViewModel {
    let userData = UserManager.shared
    let ref = FirestoreEndpoint.users.ref
    let firestoreManager = FirestoreManager.shared
    
    func updateMixColor(colorHex: String) {
        firestoreManager.updateDocument(data: [UserProperty.mixColorToday.rawValue: colorHex], collection: ref, docID: userData.id)
    }
    
    func updateColorToday(colorHex: String) {
        firestoreManager.updateDocument(data: [UserProperty.colorToday.rawValue: colorHex], collection: ref, docID: userData.id)
    }
}
