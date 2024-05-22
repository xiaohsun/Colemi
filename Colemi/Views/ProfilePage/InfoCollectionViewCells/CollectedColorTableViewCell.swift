//
//  CollectedColorTableViewCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/18/24.
//

import UIKit

class CollectedColorTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "\(CollectedColorTableViewCell.self)"
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var hexColorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 16)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = "#123451"
        
        return label
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#CCCCCC")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.addSubview(colorView)
        containerView.addSubview(hexColorLabel)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.heightAnchor.constraint(equalTo: colorView.heightAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            
            colorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor),
            colorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            colorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            hexColorLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 20),
            hexColorLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separatorView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 15),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectedColorTableViewCell {
    func update(hexColor: String) {
        colorView.backgroundColor = UIColor(hex: hexColor)
        hexColorLabel.text = hexColor
    }
}
