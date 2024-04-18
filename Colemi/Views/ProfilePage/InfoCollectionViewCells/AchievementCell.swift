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
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    lazy var footprintLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.text = "成就"
        
        return label
    }()
    
    lazy var footprintNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.text = "3"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.addSubview(footprintLabel)
        containerView.addSubview(footprintNumberLabel)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            footprintLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            footprintLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            footprintNumberLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            footprintNumberLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}