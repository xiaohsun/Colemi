//
//  ColorSimilarityViewModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/15/24.
//

import UIKit

class ColorSimilarityViewModel {
    
    var colorsDistance: [Double] = []
    
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
}
