//
//  SignOutCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/6/24.
//

import UIKit
import FirebaseAuth

class SignOutCell: UITableViewCell {
    
    weak var delegate: SignOutCellDelegate?
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(ThemeColorProperty.lightColor.getColor(), for: .normal)
        button.setTitle("登出", for: .normal)
        button.titleLabel?.font = ThemeFontProperty.GenSenRoundedTW_R.getFont(size: 18)
        button.backgroundColor = UIColor(hex: "036DA4")
        button.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        return button
    }()
    
    @objc private func signOutButtonTapped() {
        let firebaseAuth = Auth.auth()
        
        let signOutAlert = UIAlertController(title: "登出", message: "確定要登出嗎?", preferredStyle: .alert)
        let signOutSuccessAlert = UIAlertController(title: "已登出", message: "請重新登入", preferredStyle: .alert)
        let signOutFailAlert = UIAlertController(title: "已登出", message: "請重新登入", preferredStyle: .alert)
        
        signOutAlert.addAction(UIAlertAction(title: "登出", style: .default, handler: { _ in
            do {
              try firebaseAuth.signOut()
                
                self.delegate?.presentSignOutAlert(alert: signOutSuccessAlert)
                
            } catch let signOutError as NSError {
                
              print("Error signing out: %@", signOutError)
                
                self.delegate?.presentSignOutAlert(alert: signOutFailAlert)
            }
        }))
        
        signOutSuccessAlert.addAction(UIAlertAction(title: "好的", style: .default, handler: { _ in
            
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                return
            }
            
            let preLoginInViewController = PreLoginInViewController()
            
            UIView.transition(with: sceneDelegate.window!,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                sceneDelegate.window?.rootViewController = preLoginInViewController
            })
        }))

        signOutAlert.addAction(UIAlertAction(title: "取消", style: .cancel))
        delegate?.presentSignOutAlert(alert: signOutAlert)
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

protocol SignOutCellDelegate: AnyObject {
    func presentSignOutAlert(alert: UIAlertController)
}
