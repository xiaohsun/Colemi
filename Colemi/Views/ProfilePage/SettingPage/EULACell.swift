//
//  EULACell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/10/24.
//

import UIKit

class EULACell: UITableViewCell {
    
    weak var delegate: EULACellDelegate?
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(ThemeColorProperty.darkColor.getColor(), for: .normal)
        button.setTitle("使用者條款", for: .normal)
        button.titleLabel?.font = UIFont(name: FontProperty.GenSenRoundedTW_R.rawValue, size: 18)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        return button
    }()
    
    @objc private func btnTapped() {
        delegate?.presentEULAPopUp()
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


protocol EULACellDelegate: AnyObject {
    func presentEULAPopUp()
}
