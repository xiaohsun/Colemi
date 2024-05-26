//
//  MissionCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit

class MissionCell: UITableViewCell {
    
    static let reuseIdentifier = "\(MissionCell.self)"
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        view.layer.cornerRadius = RadiusProperty.radiusTwenty.rawValue
        
        return view
    }()
    
    lazy var missionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 16)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = "今日任務"
        
        return label
    }()
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColorProperty.darkColor.getColor()
        view.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.addSubview(missionLabel)
        containerView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            containerView.heightAnchor.constraint(equalToConstant: 50),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            missionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            missionLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            colorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 20),
            colorView.leadingAnchor.constraint(equalTo: missionLabel.trailingAnchor, constant: 15),
            colorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MissionCell {
    func update(color: String) {
        colorView.backgroundColor = UIColor(hex: color)
    }
}
