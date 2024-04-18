//
//  MyChatBubbleTableViewCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit

class MyChatBubbleTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "\(MyChatBubbleTableViewCell.self)"
    
    lazy var messageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.text = "嗨嗨"
        
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = .white
        contentView.addSubview(messageView)
        contentView.addSubview(messageLabel)
        
        
        NSLayoutConstraint.activate([
            messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 100),
            messageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            
            messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 15),
            messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -15),
            messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 15),
            messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -15)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
