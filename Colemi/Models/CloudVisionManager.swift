//
//  CloudVisionManager.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/14/24.
//

import Foundation

class CloudVisionManager {
    
    var apiKey = "nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC9WihbywH8rpeQ\nhP+VhALQHkCPwtNEIKf6q2kc6Ou08OXBJSWfgN6n4D7DLuH/m2PZh1BA67o1RKjD\nz1NS5mAC91QoL3u/7q7K7A9GVIT12DufFBjotsWIJ8M3YV0iSHvSgm3upug39wWe\nrF9EBLGSlZgzwKUyniiDZD0a6URR7aUdN1v5ejm1iTQUMbL1Lvq+5vSoJkEXkwza\nuFetIq3MhaS285o6wZmqbHT2DdbZTvO/7B0AN49Yvk4GEVLZpRJ2/httqFn1k9CN\nGLXLMcfY12uaZMpCtRXc2aoA0czls1i+zWMEuNd72m2glHn0IwfRthopS0nLICjH\nXcg1rZlfAgMBAAECggEACwJrd07Z6jmyiU4aWDSpPzWLFnDC/OKTMcF2pp4qWkZp\nbW39/oStLYCd1ZZrwINl7lduRKAQHxnDYEM1Oow3h+SeiYmdPd8gXZ8VEkdGxc6R\nROITwrAh0xVQxe8Mzbn+LRK1VptwxBRCSOQH0/ob4wR8qYGpeUR14ZHZ9a8bcFHx\n2DSaHi5rAh/+tiGt4q5xSFUFG6G0KTbAqKlfjrpcLoWqIgT+LeFglpY3zxLsKxiX\nJ5Tm5ctTlgCz0F4TW6QeOE3VJB11ECl1nuQtYy1LTmn6FoATj7Y9u5zvG54e4byO\naDQsetyUBYahiC8wG37VBKrePSLE9bUDgxf8ZSDRKQKBgQDlkCHEE3qSxNC2oPan\nvJOGZWv4GHnXgpZdHcsjkp2RGhz0SigOykboI5TiPBsoyXOc1L6225IcYMiYUuDn\nZ7iV8ZQrZ921Vl89UJXBXP/8IR4t9cv7z/g5Yf1OUezaIsLFZmRY5zl0Q97MMS1r\n3Wqy4RMAAnVE+/hda4Igk96XmQKBgQDTKIyEzKsW/5Fd92uMdOG66BbSMTomAGsK\n8cOAe85hiJkVfTZ8f+1xms7yec5zvvwkN7pzXW8sZ5CLeIvF7Ph85VjpEp3rwq0m\nNW/0+krBW4egTWqMBMXVeBhWZ+Z+V+NdUBuZWLcfoDTvApXUB889fkQcq7kXFaHI\nmNwxapHztwKBgQC843S1JqXzwBhQPW/XIvZsXmWRtWoD5wKcSdiNQ6V88HSkmaQO\nT2g6uJRX9scOL3x+rhri0RaPXR+RHpjKL3EVh7q4YHVwMUqaZAVlHoXPStzPSnF2\nmHARn0xTNlviPTnwPUkSUefXf8UCVPCf0Ydq+oGsv1kI0x9QlxZygdlk+QKBgDBT\njG1sRg/aZ9Ogp62apnrXWTm76HoACH+Vu0+xhhdOYvLHGGw//wDMFGbsN7LH1/8V\n/gcfMC1yemNhMGQZCvnSp5mYGCp4AJbJDhl8GxXLs+udLDBlez2S4ccMunTZ+oBF\nsDtVUXvcd6Dn75B6RRTmzAHfz1mYKtG1Ilfw8vxbAoGBAMPNcbKRZlnoZHxmPdnH\n7+YEOi/qLZgJNa4uKn3FS/UYNw9v7APeKhEbb6q5QIEk1BSm7UhR4sXW+UEsDTwM\nFMwocTGVYPSlK69knNdMbYzkUe05KhPIJxjz73QqehtSirG17m9cMEumpHdq0xKc\n8K26pem0slZMMWK4X6L4luny"
    
    func analyzeImageWithVisionAPI(imageData: Data, completion: @escaping ([String: Any]?, Error?) -> Void) {

        let url = URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let base64Image = imageData.base64EncodedString()
        let requestBody = [
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
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                print(error.localizedDescription)
                return
            }
            
            do {
                if let data = data,
                   let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(json, nil)
                } else {
                    completion(nil, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
