//
//  ChatBubbleTableViewCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit

class OtherChatBubbleTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "\(OtherChatBubbleTableViewCell.self)"
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = ThemeColorProperty.darkColor.getColor()
        
        return imageView
    }()
    
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
        label.text = "dleqwfkewmlkfmklfmwkflewmfklewmfklwemfklmfeklwmfkwlemfweklfmkwelewmkfmwleklfmlw"
        
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(avatarImageView)
        contentView.addSubview(messageView)
        contentView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            messageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            messageView.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            messageView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -100),
            messageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            
            messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 15),
            messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -15),
            messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 15),
            messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -15)
        ])
    }
    
    override func layoutSubviews() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OtherChatBubbleTableViewCell {
    func update(messageData: Message) {
        messageLabel.text = messageData.body
    }
}
