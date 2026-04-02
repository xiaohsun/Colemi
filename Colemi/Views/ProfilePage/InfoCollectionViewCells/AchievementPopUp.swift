//
//  AchievementPopUp.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/12/24.
//

import UIKit

class AchievementPopUp: UIViewController {
    
    var containerViewTopCons: NSLayoutConstraint?
    var containerViewHeight: CGFloat = 340
    var verificationResult: AchievementVerificationResult = .loading(config: .demo)
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = RadiusProperty.radiusTwenty.rawValue
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "成就"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 20)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 18)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.textAlignment = .center
        return label
    }()

    lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 15)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        return label
    }()

    lazy var networkLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 15)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        return label
    }()

    lazy var contractLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 15)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        return label
    }()

    lazy var checkedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 15)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        return label
    }()

    lazy var detailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func dismissPopUp() {
        hide()
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(statusLabel)
        containerView.addSubview(detailStackView)
        containerView.addSubview(closeButton)

        detailStackView.addArrangedSubview(badgeLabel)
        detailStackView.addArrangedSubview(networkLabel)
        detailStackView.addArrangedSubview(contractLabel)
        detailStackView.addArrangedSubview(checkedLabel)
        
        containerViewTopCons = containerView.topAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewTopCons?.isActive = true
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: containerViewHeight),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 10),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 22),
            statusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            detailStackView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            detailStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            detailStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        render()
        backgroundAddGesture()
    }

    func render() {
        statusLabel.text = verificationResult.popupStatusText
        badgeLabel.text = "Badge: \(verificationResult.badgeName)"
        networkLabel.text = "Network: \(verificationResult.chainName)"
        contractLabel.text = "Contract: \(verificationResult.shortContractAddress)"
        checkedLabel.text = "Last checked: \(verificationResult.lastCheckedText)"
    }
    
    private func backgroundAddGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.isUserInteractionEnabled = true
    }
    
    func appear(sender: UIViewController) {
        self.modalPresentationStyle = .overFullScreen
        sender.present(self, animated: false) {
            self.containerViewTopCons?.isActive = false
            self.containerViewTopCons = self.containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            self.containerViewTopCons?.isActive = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                self.backgroundView.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func hide() {
        self.containerViewTopCons?.isActive = false
        self.containerViewTopCons = self.containerView.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.containerViewTopCons?.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
            self.view.layoutIfNeeded()
            self.backgroundView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
}
