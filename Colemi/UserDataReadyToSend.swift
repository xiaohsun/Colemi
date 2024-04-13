//
//  UserDataReadyToSend.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/13/24.
//

import Foundation

class UserDataReadyToSend: Codable, Identifiable {
    var id = UUID()
    // let name: String
    let color: String
    
    init(color: String) {
      self.color = color
    }
    
    func data() -> Data? {
      let encoder = JSONEncoder()
      return try? encoder.encode(self)
    }
}
