//
//  ChatRoomTableViewCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/20/24.
//
import UIKit

class ChatRoomTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "\(ChatRoomTableViewCell.self)"
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = ThemeColorProperty.darkColor.getColor()
        
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = "勳寶貝"
        label.font = UIFont(name: FontProperty.GenSenRoundedTW_M.rawValue, size: 18)
        
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = "你真是太棒了"
        label.font = UIFont(name: FontProperty.GenSenRoundedTW_R.rawValue, size: 18)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -100),
            
            messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -150),
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatRoomTableViewCell {
    func update(simpleChatRoomData: SimpleChatRoom) {
        messageLabel.text = simpleChatRoomData.latestMessage
        nameLabel.text = simpleChatRoomData.receiverName
    }
}