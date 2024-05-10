//
//  WeatherInfoPopUp.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/10/24.
//

import UIKit

class WeatherInfoPopUp: UIViewController {
    
    var containerViewTopCons: NSLayoutConstraint?
    var containerViewYCons: NSLayoutConstraint?
    
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
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: FontProperty.GenSenRoundedTW_M.rawValue, size: 14)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = """
        Colemi 會使用您所在位置的天氣資料，資料來源為  Weather：
        https://weatherkit.apple.com/legal-attribution.html
        """
        
        return label
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
    
    private func setUpUI() {
        view.backgroundColor = .clear
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(closeButton)
        containerView.addSubview(contentLabel)
        
        containerViewTopCons = containerView.topAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewTopCons?.isActive = true
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            closeButton.widthAnchor.constraint(equalToConstant: 10),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentLabel.addLineSpacing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        backgroundAddGesture()
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
            self.containerViewYCons = self.containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            self.containerViewYCons?.isActive = true
            UIView.animate(withDuration: 0.2) {
                self.backgroundView.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func hide() {
        self.containerViewTopCons?.constant = 0
        self.containerViewYCons?.constant = 1000
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.backgroundView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
}
