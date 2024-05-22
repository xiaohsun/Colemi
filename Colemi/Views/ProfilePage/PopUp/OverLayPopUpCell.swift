//
//  OverLayPopUpCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/4/24.
//

import UIKit

class OverLayPopUpCell: UITableViewCell {
    
    static let reuseIdentifier = "\(OverLayPopUpCell.self)"
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ThemeColorProperty.darkColor.getColor()
        
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ThemeFontProperty.GenSenRoundedTW_R.getFont(size: 18)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = "檢舉"
        
        return label
    }()
    
    func setUpUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -20),
            iconImageView.widthAnchor.constraint(equalToConstant: 23),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10)
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
}

extension OverLayPopUpCell {
    func update() {
        label.text = "封鎖"
        iconImageView.image = UIImage(systemName: "nosign")?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = ThemeColorProperty.darkColor.getColor()
    }
}
    
