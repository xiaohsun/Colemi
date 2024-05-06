//
//  DeleteAccountCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/6/24.
//

import UIKit

class DeleteAccountCell: UITableViewCell {
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(ThemeColorProperty.lightColor.getColor(), for: .normal)
        button.setTitle("刪除帳號", for: .normal)
        button.titleLabel?.font = UIFont(name: FontProperty.GenSenRoundedTW_R.rawValue, size: 18)
        button.backgroundColor = UIColor(hex: "EE4A43")
        // button.backgroundColor = UIColor(hex: "DC2B37")
        button.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        return button
    }()
    
    @objc private func deleteAccountButtonTapped() {
        print("Delete Account")
    }
    
    private func setUpUI() {
        contentView.addSubview(button)
        contentView.backgroundColor = ThemeColorProperty.darkColor.getColor()
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
