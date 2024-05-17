//
//  ChangeNameCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/12/24.
//

import UIKit

class ChangeNameCell: UITableViewCell {
    
    let viewModel = SettingViewModel()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = ThemeFontProperty.GenSenRoundedTW_R.getFont(size: 18)
        label.textColor = .white
        label.text = "更改名稱"
        
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .white
        textField.text = viewModel.userData.name
        textField.delegate = self
        // textField.textAlignment = .center
        
        return textField
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = ThemeFontProperty.GenSenRoundedTW_R.getFont(size: 18)
        label.textColor = .white
        label.text = viewModel.userData.name
        
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private func setUpUI() {
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameTextField)
        contentView.backgroundColor = ThemeColorProperty.darkColor.getColor()
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameTextField.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -10),
            nameTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 15),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
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

extension ChangeNameCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.updateUserName(newName: textField.text ?? "我是誰")
    }
}
