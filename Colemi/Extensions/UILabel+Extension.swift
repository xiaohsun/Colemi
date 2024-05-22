//
//  UILabel+Extension.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/30/24.
//

import UIKit

extension UILabel {
    func addLineSpacing(lineSpacing: CGFloat = 5) {
        if let labelText = text, !labelText.isEmpty {
            
            let attributedString = NSMutableAttributedString(string: labelText)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            
            attributedText = attributedString
        }
    }
    
//    func addCharacterSpacing(kernValue: Double = 1.15) {
//        if let labelText = text, labelText.count > 0 {
//            
//            let attributedString = NSMutableAttributedString(string: labelText)
//            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
//            
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 5
//            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
//            
//            attributedText = attributedString
//        }
//    }
}
