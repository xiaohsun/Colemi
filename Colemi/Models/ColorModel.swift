//
//  ColorModel.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/12/24.
//

import UIKit

struct ColorModel {
    
    var sunnyColors: [UIColor] = [UIColor(red: 166/255, green: 237/255, blue: 237/255, alpha: 1), UIColor(red: 254/255, green: 255/255, blue: 168/255, alpha: 1), UIColor(red: 255/255, green: 138/255, blue: 138/255, alpha: 1)]
    
    // 藍、黃、紅
    var sunnyColorsHex: [String] = ["#A6EDED", "#FEFFA8", "#FF8A8A"]
    
    var rainColors: [UIColor] = [UIColor(red: 139/255, green: 174/255, blue: 170/255, alpha: 1), UIColor(red: 2/255, green: 90/255, blue: 106/255, alpha: 1), UIColor(red: 181/255, green: 192/255, blue: 186/255, alpha: 1)]
    
    var rainColorsHex: [String] = ["#8BAEAA", "#025A6A", "#B5C0BA"]
    
    var sunnyColorsMix: [UIColor] = [UIColor(red: 182/255, green: 226/255, blue: 161/255, alpha: 1), UIColor(red: 229/255, green: 212/255, blue: 255/255, alpha: 1), UIColor(red: 254/255, green: 190/255, blue: 140/255, alpha: 1)]
    
    var rainColorsMix: [UIColor] = [UIColor(red: 60/255, green: 113/255, blue: 154/255, alpha: 1), UIColor(red: 173/255, green: 192/255, blue: 152/255, alpha: 1), UIColor(red: 84/255, green: 81/255, blue: 139/255, alpha: 1)]
    
    // 綠、紫、橘
    var sunnyColorsMixHex: [String] = ["#B6E2A1", "#DCBFFF", "#FEBE8C"]
}
