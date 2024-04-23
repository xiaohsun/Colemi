//
//  BestColorCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit

class BestColorCell: UICollectionViewCell {
    
    static let reuseIdentifier = "\(BestColorCell.self)"
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColorProperty.darkColor.getColor()
        view.layer.cornerRadius = RadiusProperty.radiusTwenty.rawValue
        
        return view
    }()
    
    lazy var bestColorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.text = "最準顏色"
        
        return label
    }()
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.addSubview(bestColorLabel)
        containerView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            bestColorLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            bestColorLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            colorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            colorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            colorView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.2),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
