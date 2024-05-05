//
//  FollowTableViewCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/5/24.
//

import UIKit

class FollowTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "\(FollowTableViewCell.self)"
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = ThemeColorProperty.darkColor.getColor()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontProperty.GenSenRoundedTW_R.rawValue, size: 16)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = ""
        
        return label
    }()
    
    func setUpUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(label)
        contentView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 25),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
}

extension FollowTableViewCell {
    func update(avatarUrl: String, userName: String) {
        let url = URL(string: avatarUrl)
        avatarImageView.kf.setImage(with: url)
        label.text = userName
    }
}
    
