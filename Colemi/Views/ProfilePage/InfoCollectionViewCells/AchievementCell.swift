//
//  AchievementCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit

class AchievementCell: UICollectionViewCell {
    
    static let reuseIdentifier = "\(AchievementCell.self)"
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColorProperty.darkColor.getColor()
        view.layer.cornerRadius = RadiusProperty.radiusTwenty.rawValue
        
        return view
    }()
    
    lazy var achievementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 14)
        label.textColor = .white
        label.text = "成就"
        
        return label
    }()
    
    lazy var footprintNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 16)
        label.textColor = .white
        label.text = "0"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.addSubview(achievementLabel)
        containerView.addSubview(footprintNumberLabel)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            achievementLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            achievementLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            footprintNumberLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            footprintNumberLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
