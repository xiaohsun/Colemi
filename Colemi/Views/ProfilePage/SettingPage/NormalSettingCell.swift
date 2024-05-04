//
//  NormalSettingCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/3/24.
//

import UIKit

class NormalSettingCell: UITableViewCell {
    
    static let reuseIdentifier = "\(NormalSettingCell.self)"
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont(name: FontProperty.GenSenRoundedTW_R.rawValue, size: 18)
        label.textColor = .white
        label.text = "123"
        
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private func setUpUI() {
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.backgroundColor = ThemeColorProperty.darkColor.getColor()
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 15),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
