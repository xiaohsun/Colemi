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
        view.backgroundColor = UIColor(hex: "#F9F4E8")
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    lazy var missionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "今日任務"
        
        return label
    }()
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 10
        
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
            containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/3),
            // containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            // containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            missionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            missionLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            colorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 20),
            colorView.leadingAnchor.constraint(equalTo: missionLabel.trailingAnchor, constant: 10),
            colorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}