//
//  AppThemeColor.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/22/24.
//

import UIKit

enum ThemeColorProperty {
    case lightColor
    case darkColor
    
    func getColor() -> UIColor {
        switch self {
        case .lightColor:
            return UIColor(hex: "#F9F4E8") ?? UIColor.black
        case .darkColor:
            return UIColor(hex: "#4D4D4D") ?? UIColor.black
        }
    }
}

enum RadiusProperty: CGFloat {
    case radiusTen = 10
    case radiusTwenty = 20
}
