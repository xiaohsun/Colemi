//
//  UITextField+Extension.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/28/24.
//

import UIKit

extension UITextView {
    
    func addLineSpacing() {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            let attributes = [NSAttributedString.Key.paragraphStyle : paragraphStyle]
            typingAttributes = attributes
        }
    
    func addCharacterSpacing(kernValue: Double = 1.15) {
        if let textString = text, !textString.isEmpty {
            let previousTextColor = textColor
            
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            
            attributedText = attributedString
            
            textColor = previousTextColor
        }
    }
}
