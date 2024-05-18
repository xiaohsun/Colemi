//
//  ColorFootprintPopUpViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/18/24.
//

import Foundation

class ColorFootprintPopUpViewModel {
    
    let userData = UserManager.shared
    let fireManager = FirestoreManager.shared
    
    var topTenUsers: [User] = []
    
    func getUsersData(completion: @escaping () -> Void) {
        let ref = FirestoreEndpoint.users.ref
        let query = ref.order(by: UserProperty.colorPoints.rawValue, descending: true).limit(to: 10)
        let firestoreManager = FirestoreManager.shared
        
        self.topTenUsers = []
        
        firestoreManager.getDocuments(query) { [weak self] (users: [User]) in
            guard let `self` = self else { return }
            self.topTenUsers = users
            completion()
        }
    }
}
