//
//  TextViewCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit

class TextViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "\(TextViewCell.self)"
    weak var delegate: TextViewCellDelegate?
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = RadiusProperty.radiusTwenty.rawValue
        
        return view
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "新增個人描述"
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 14)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 14)
        textView.textColor = ThemeColorProperty.darkColor.getColor()
        textView.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        textView.delegate = self
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.addSubview(textView)
        containerView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            placeholderLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor, constant: -1.5),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 4)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension TextViewCell {
    func update(description: String, isOthersPage: Bool) {
        textView.text = description
        textView.isEditable = !isOthersPage
        
        if !textView.text.isEmpty {
            placeholderLabel.alpha = 0
        }
    }
}

extension TextViewCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.userDescriptionChange(text: textView.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            placeholderLabel.alpha = 0
        } else {
            placeholderLabel.alpha = 1
        }
    }
}

protocol TextViewCellDelegate: AnyObject {
    func userDescriptionChange(text: String)
}
