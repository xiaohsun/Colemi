//
//  DeleteAccountCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/6/24.
//

import UIKit

class DeleteAccountCell: UITableViewCell {
    
    weak var delegate: DeleteAccountCellDelegate?
    
    let authenticationViewModel = AuthenticationViewModel()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(ThemeColorProperty.lightColor.getColor(), for: .normal)
        button.setTitle("刪除帳號", for: .normal)
        button.titleLabel?.font = ThemeFontProperty.GenSenRoundedTW_R.getFont(size: 18)
        button.backgroundColor = UIColor(hex: "EE4A43")
        // button.backgroundColor = UIColor(hex: "DC2B37")
        button.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        return button
    }()
    
    @objc private func deleteAccountButtonTapped() {
        
        let alert1 = UIAlertController(title: "刪除帳號", message: "你確定要刪除帳號嗎？所有的資料將會消失唷！", preferredStyle: .alert)
        
        alert1.addAction(UIAlertAction(title: "確定", style: .default, handler: { _ in
            Task { 
                await self.authenticationViewModel.deleteAccount { title, content, isSuccess in
                    let alert2 = UIAlertController(title: title, message: content, preferredStyle: .alert)
                    alert2.addAction(UIAlertAction(title: "好的", style: .default, handler: { _ in
                        if isSuccess {
                            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                                return
                            }
                            
                            let loggedInViewController = SignInViewController()
                            
                            UIView.transition(with: sceneDelegate.window!,
                                              duration: 0.3,
                                              options: .transitionCrossDissolve,
                                              animations: {
                                sceneDelegate.window?.rootViewController = loggedInViewController
                            })
                        }
                    }))
                    self.delegate?.presentAlert(alert: alert2)
                }
            }
        }))

        alert1.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        delegate?.presentAlert(alert: alert1)
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

protocol DeleteAccountCellDelegate: AnyObject {
    func presentAlert(alert: UIAlertController)
}
