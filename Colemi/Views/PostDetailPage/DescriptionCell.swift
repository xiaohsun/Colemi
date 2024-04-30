//
//  descriptionCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/17/24.
//

import UIKit

class DescriptionCell: UITableViewCell {
    
    static let reuseIdentifier = "\(DescriptionCell.self)"
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: FontProperty.GenSenRoundedTW_R.rawValue, size: 14)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }()
    
    func setUpUI() {
        contentView.addSubview(descriptionLabel)
        contentView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
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

extension DescriptionCell {
    func update(content: Content) {
        descriptionLabel.text = content.description
        descriptionLabel.addCharacterSpacing()
    }
}
