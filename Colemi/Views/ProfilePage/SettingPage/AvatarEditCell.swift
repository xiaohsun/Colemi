//
//  AvatarEditCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/3/24.
//

import UIKit

class AvatarEditCell: UITableViewCell {
    
    static let reuseIdentifier = "\(AvatarEditCell.self)"
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarGetTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        return imageView
    }()
    
    @objc private func avatarGetTapped(_ sender: UITapGestureRecognizer) {
        print("change!")
    }
    
    private func setUpUI() {
        contentView.addSubview(avatarImageView)
        contentView.backgroundColor = ThemeColorProperty.darkColor.getColor()
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
}
