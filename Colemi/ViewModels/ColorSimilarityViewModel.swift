//
//  ColorSimilarityViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/15/24.
//

import UIKit

class ColorSimilarityViewModel {
    
    let userData = UserManager.shared
    var colorsDistance: [Double] = []
    var postID: String = ""
    
    func caculateColorDistance(selectedUIColor: UIColor, colors: [Color]) -> [Double] {
        for color in colors {
            let red = CGFloat(color.color.red ?? 0) / 255
            let green = CGFloat(color.color.green ?? 0) / 255
            let blue = CGFloat(color.color.blue ?? 0) / 255
            let distance = selectedUIColor.CIEDE2000(compare: UIColor(red: red, green: green, blue: blue, alpha: 1))
            colorsDistance.append(distance)
        }
        
        // return colorsDistance.min() ?? 0
        return colorsDistance
    }
    
    func updatePostData(colorPoints: Int) {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.posts.ref
        
        let updateData: [String: Any] = [
            PostProperty.colorPoints.rawValue: colorPoints
        ]
        
        firestoreManager.updateMutipleDocument(data: updateData, collection: ref, docID: postID)
    }
    
    func updateUserData(colorPoints: Int) {
        let firestoreManager = FirestoreManager.shared
        let ref = FirestoreEndpoint.users.ref
        userData.colorPoints += colorPoints
        
        if !userData.collectedColors.contains(userData.colorToday) {
            userData.collectedColors.append(userData.colorToday)
        }
        
        let updateData: [String: Any] = [
            UserProperty.colorPoints.rawValue: userData.colorPoints,
            UserProperty.collectedColors.rawValue: userData.collectedColors,
        ]
        
        firestoreManager.updateMutipleDocument(data: updateData, collection: ref, docID: userData.id)
    }
}
