//
//  CloudVisionManager.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/14/24.
//

import Foundation

class CloudVisionManager {
    
    weak var delegate: CloudVisionManagerDelegate?
    
    var apiKey = "AIzaSyDvV7Oc5opzGdY_UDsDufy4kfDbMehoZ74"
    
    func analyzeImageWithVisionAPI(imageData: Data, url: String) {

        let url = URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let base64Image = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let requestBody: [String: Any] = [
            "requests": [
                [
                    "image": [
                        "content": base64Image
                    ],
                    "features": [
                        [
                            "maxResults": 10,
                            "type": "IMAGE_PROPERTIES"
                        ]
                    ]
                ]
            ]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let safeData = data {
                // let content = String(data: safeData, encoding: .utf8)
                // print(content!)
                
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(CloudVisionResponse.self, from: safeData)
                    let colors = decodedData.responses[0].imagePropertiesAnnotation.dominantColors.colors
                    self.delegate?.getColorsRGB(colors: colors)
                    
                } catch {
                    print("error: \(error)")
                    return
                }
            }
        }
        task.resume()
    }
}

protocol CloudVisionManagerDelegate: AnyObject {
    func getColorsRGB(colors: [Color])
}