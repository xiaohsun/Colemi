//
//  RankingCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/18/24.
//

import UIKit

class RankingCell: UITableViewCell {
    
    static let reuseIdentifier = "\(RankingCell.self)"
    
    lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 16)
        label.textColor = ThemeColorProperty.lightColor.getColor()
        label.text = "1"
        
        return label
    }()
    
    lazy var rankLabelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColorProperty.darkColor.getColor()
        
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 16)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = "勳寶"
        
        return label
    }()
    
    lazy var colorPointsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 16)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = "2345"
        
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
        contentView.addSubview(rankLabelContainerView)
        rankLabelContainerView.addSubview(rankLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(colorPointsLabel)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            rankLabelContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            rankLabelContainerView.heightAnchor.constraint(equalTo: rankLabelContainerView.widthAnchor),
            rankLabelContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            rankLabelContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            rankLabel.centerXAnchor.constraint(equalTo: rankLabelContainerView.centerXAnchor),
            rankLabel.centerYAnchor.constraint(equalTo: rankLabelContainerView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: rankLabelContainerView.trailingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: rankLabelContainerView.centerYAnchor),
            
            colorPointsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            colorPointsLabel.centerYAnchor.constraint(equalTo: rankLabel.centerYAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: rankLabelContainerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: colorPointsLabel.trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: rankLabelContainerView.bottomAnchor, constant: 10),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        rankLabelContainerView.layer.cornerRadius = rankLabelContainerView.frame.width / 2
    }
}

extension RankingCell {
    func update(index: Int, colorPoints: Int, userName: String) {
        rankLabel.text = String(index)
        colorPointsLabel.text = String(colorPoints)
        nameLabel.text = userName
    }
}
