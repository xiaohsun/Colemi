//
//  ColorPointsCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/18/24.
//

import UIKit

class ColorPointsCell: UITableViewCell {
    
    lazy var colorPointsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = ThemeFontProperty.GenSenRoundedTW_R.getFont(size: 14)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }()
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    func setUpUI() {
        contentView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        
        contentView.addSubview(colorView)
        contentView.addSubview(colorPointsLabel)
        
        NSLayoutConstraint.activate([
//            colorView.centerYAnchor.constraint(equalTo: colorPointsLabel.centerYAnchor),
//            colorView.trailingAnchor.constraint(equalTo: colorPointsLabel.leadingAnchor, constant: -8),
//            colorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.06),
//            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor),
//            
//            colorPointsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            colorPointsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
//            colorPointsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            colorView.centerYAnchor.constraint(equalTo: colorPointsLabel.centerYAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            colorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.06),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor),
            
            colorPointsLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 8),
            colorPointsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            colorPointsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
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

extension ColorPointsCell {
    func update(colorPoints: Int, color: String) {
        colorPointsLabel.text = "顏色足跡 \(colorPoints)"
        colorView.backgroundColor = UIColor(hex: color)
    }
}
