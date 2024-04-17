//
//  PostDetailViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/17/24.
//

import Foundation

class PostDetailViewModel {
    
    weak var delegate: PostDetailViewModelDelegate?
    
    func decodeContent(jsonString: String) {
        let cleanedString = jsonString.replacingOccurrences(of: "\\", with: "")
        
        guard let jsonData = cleanedString.data(using: .utf8) else {
            print("Can't transform String to jsonData")
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(Content.self, from: jsonData)
            delegate?.passContentData(content: decodedData)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}

protocol PostDetailViewModelDelegate: AnyObject {
    func passContentData(content: Content)
}
