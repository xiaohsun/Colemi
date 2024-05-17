//
//  FontProperty.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/27/24.
//

import UIKit

enum FontProperty: String {
    case GenSenRoundedTW_EL = "GenSenRoundedTW-EL"
    case GenSenRoundedTW_L = "GenSenRoundedTW-L"
    case GenSenRoundedTW_R = "GenSenRoundedTW-R"
    case GenSenRoundedTW_M = "GenSenRoundedTW-M"
    case GenSenRoundedTW_B = "GenSenRoundedTW-B"
    case GenSenRoundedTW_H = "GenSenRoundedTW-H"
}

enum ThemeFontProperty: String {
    case GenSenRoundedTW_EL = "GenSenRoundedTW-EL"
    case GenSenRoundedTW_L = "GenSenRoundedTW-L"
    case GenSenRoundedTW_R = "GenSenRoundedTW-R"
    case GenSenRoundedTW_M = "GenSenRoundedTW-M"
    case GenSenRoundedTW_B = "GenSenRoundedTW-B"
    case GenSenRoundedTW_H = "GenSenRoundedTW-H"
    
    func getFont(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
