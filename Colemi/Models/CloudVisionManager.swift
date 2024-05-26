//
//  CloudVisionManager.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/14/24.
//

import Foundation
import Combine

struct APIKey: Decodable {
    let CloudVisionAPIKey: String
}

class CloudVisionManager {
    
    private var subscriptions = Set<AnyCancellable>()
    
    var apiKey: String {
        guard let plistPath = Bundle.main.path(forResource: "APIKey", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: plistPath),
              let apiKey = plistDict["CloudVisionAPIKey"] as? String else {
            fatalError("API key not found in plist")
        }
        return apiKey
    }
    
    func analyzeImageWithVisionAPI(imageData: Data, url: String) -> Future<[Color], Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            
            let url = URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(self.apiKey)")!
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
                                "maxResults": 5,
                                "type": "IMAGE_PROPERTIES"
                            ]
                        ]
                    ]
                ]
            ]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize request body"])))
                return
            }
            request.httpBody = jsonData
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { result -> Data in
                    if let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                        throw URLError(.badServerResponse)
                    }
                    return result.data
                }
                .decode(type: CloudVisionResponse.self, decoder: JSONDecoder())
                .map { $0.responses[0].imagePropertiesAnnotation.dominantColors.colors }
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        promise(.failure(error))
                    }
                } receiveValue: { colors in
                    promise(.success(colors))
                }
                .store(in: &self.subscriptions)
        }
    }
}
