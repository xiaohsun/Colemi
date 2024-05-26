//
//  UserDataReadyToSend.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/13/24.
//

import UIKit

class UserDataReadyToSend: Codable, Identifiable {
    var id = UUID()
    var color: String
    
    init(color: String) {
        self.color = color
    }
    
    func data() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
