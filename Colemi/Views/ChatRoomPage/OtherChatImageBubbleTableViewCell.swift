//
//  OtherChatImageBubbleTableViewCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/10/24.
//

import UIKit
import Kingfisher

class OtherChatImageBubbleTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "\(OtherChatImageBubbleTableViewCell.self)"
    
    var imageMessageViewWidthCons: NSLayoutConstraint?
    var imageMessageViewHeightCons: NSLayoutConstraint?
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(hex: "#BEC7B4")?.withAlphaComponent(0.35)
        imageView.clipsToBounds = true
        imageView.backgroundColor = ThemeColorProperty.darkColor.getColor()
        
        return imageView
    }()
    
    lazy var imageMessageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(hex: "#BEC7B4")?.withAlphaComponent(0.35)
        imageView.layer.cornerRadius = 15
        
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageMessageView.image = nil
        // self.layoutIfNeeded()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        self.layoutIfNeeded()
//        contentView.layoutIfNeeded()
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(avatarImageView)
        contentView.addSubview(imageMessageView)
        contentView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        
        imageMessageViewWidthCons = imageMessageView.widthAnchor.constraint(equalToConstant: 200)
        imageMessageViewWidthCons?.isActive = true
        
        imageMessageViewHeightCons = imageMessageView.heightAnchor.constraint(equalToConstant: 300)
        imageMessageViewHeightCons?.isActive = true
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 35),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            imageMessageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 15),
            imageMessageView.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            imageMessageView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50),
            imageMessageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15)
        ])
    }
    
    override func draw(_ rect: CGRect) {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OtherChatImageBubbleTableViewCell {
    func update(messageData: Message, avatarImage: UIImage) {
        let url = URL(string: messageData.body)
        avatarImageView.image = avatarImage
        KingfisherManager.shared.retrieveImage(with: url!) { result in
            switch result {
            case .success(let value):
                let image = value.image
                self.imageMessageView.image = image
                
                let imageSize = image.size
                let ratio = imageSize.height / 300
                
                let maxWidth = self.contentView.frame.width - 110
                
                if imageSize.width / ratio > maxWidth {
                    self.imageMessageViewWidthCons?.constant = maxWidth
                    let otherRatio = imageSize.width / maxWidth
                    self.imageMessageViewHeightCons?.constant = imageSize.height / otherRatio
                    self.imageMessageView.layer.cornerRadius = 15
                    
                    
                } else {
                    self.imageMessageViewWidthCons?.constant = imageSize.width / ratio
                    
                }
                
                self.contentView.layoutIfNeeded()
                
                
            case .failure(let error):
                print("Error retrieving image: \(error)")
            }

        }
    }
}
