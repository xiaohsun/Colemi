//
//  MyChatImageBubbleTableViewCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/10/24.
//

import UIKit
import Kingfisher

class MyChatImageBubbleTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "\(MyChatImageBubbleTableViewCell.self)"
    
    var imageMessageViewWidthCons: NSLayoutConstraint?
    var imageMessageViewHeightCons: NSLayoutConstraint?
    
    lazy var imageMessageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        // imageView.backgroundColor = UIColor(hex: "#BEC7B4")?.withAlphaComponent(0.35)
        imageView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageMessageView.image = nil
        // self.layoutIfNeeded()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        contentView.addSubview(imageMessageView)
        
        imageMessageViewWidthCons = imageMessageView.widthAnchor.constraint(equalToConstant: 200)
        imageMessageViewWidthCons?.isActive = true
        
        imageMessageViewHeightCons = imageMessageView.heightAnchor.constraint(equalToConstant: 300)
        imageMessageViewHeightCons?.isActive = true
        
        NSLayoutConstraint.activate([
            imageMessageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 100),
            imageMessageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            imageMessageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageMessageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyChatImageBubbleTableViewCell {
    func update(messageData: Message) {
        
        let url = URL(string: messageData.body)
        
        KingfisherManager.shared.retrieveImage(with: url!) { [weak self] result in
            guard let self else { return }
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
                    self.imageMessageViewHeightCons?.constant = 300
                    self.imageMessageViewWidthCons?.constant = imageSize.width / ratio
                }
                
                self.contentView.layoutIfNeeded()
                
            case .failure(let error):
                print("Error retrieving image: \(error)")
            }
        }
    }
}
