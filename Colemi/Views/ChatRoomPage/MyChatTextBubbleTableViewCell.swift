//
//  MyChatBubbleTableViewCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit

class MyChatTextBubbleTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "\(MyChatTextBubbleTableViewCell.self)"
    
    lazy var messageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 15
        view.layer.borderColor = ThemeColorProperty.darkColor.getColor().cgColor
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = "嗨嗨"
        label.font = UIFont(name: FontProperty.GenSenRoundedTW_R.rawValue, size: 16)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        contentView.addSubview(messageView)
        contentView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            messageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 100),
            messageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15),
            
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

extension MyChatTextBubbleTableViewCell {
    func update(messageData: Message) {
        messageLabel.text = messageData.body
    }
}
