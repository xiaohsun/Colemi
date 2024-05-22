//
//  TagCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/17/24.
//

import UIKit

class TagCell: UITableViewCell {
    
    static let reuseIdentifier = "\(TagCell.self)"
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = ThemeFontProperty.GenSenRoundedTW_R.getFont(size: 14)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = ""
        
        return label
    }()
    
    func setUpUI() {
        contentView.addSubview(tagLabel)
        contentView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        
        NSLayoutConstraint.activate([
            tagLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tagLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            tagLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
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

extension TagCell {
    func update(tag: String) {
        if tag != "" {
            tagLabel.text = "#\(tag)"
        }
    }
}
