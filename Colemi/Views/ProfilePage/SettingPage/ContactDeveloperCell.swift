//
//  ContactDeveloperCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/9/24.
//

import UIKit
import MessageUI

class ContactDeveloperCell: UITableViewCell {
    
    weak var delegate: ContactDeveloperCellDelegate?
    
    let authenticationViewModel = AuthenticationViewModel()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(ThemeColorProperty.darkColor.getColor(), for: .normal)
        button.setTitle("聯絡開發者", for: .normal)
        button.titleLabel?.font = ThemeFontProperty.GenSenRoundedTW_R.getFont(size: 18)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(contactDeveloperBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        return button
    }()
    
    @objc private func contactDeveloperBtnTapped() {
//        let composeVC = MFMailComposeViewController()
//        composeVC.mailComposeDelegate = self
//        composeVC.setToRecipients(["example@example.com"])
//        composeVC.setSubject("Example Subject")
//        composeVC.setMessageBody("Example Message", isHTML: false)
        delegate?.presentComposeVC()
    }
    
    private func setupUI() {
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
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


protocol ContactDeveloperCellDelegate: AnyObject {
    func presentComposeVC()
}
