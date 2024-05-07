//
//  LobbyPostCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/11/24.
//

import UIKit

class LobbyPostCell: UICollectionViewCell {
    static let reuseIdentifier = "\(LobbyPostCell.self)"
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(hex: "#BEC7B4")?.withAlphaComponent(0.35)
        imageView.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
