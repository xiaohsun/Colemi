//
//  PreLoginInViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/19/24.
//

import UIKit

class PreLoginInViewController: UIViewController {
    
    lazy var colorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ColemiIcon")
        return imageView
    }()
    
    lazy var withLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "和"
        label.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 20)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }()
    
    lazy var colemiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "Colemi"
        label.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 30)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }()
    
    lazy var togetherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "一起成為"
        label.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 24)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }()
    
    lazy var observerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "顏色觀察家"
        label.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 30)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColorProperty.darkColor.getColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.arrowIcon.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ThemeColorProperty.lightColor.getColor()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(arrowTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    @objc private func arrowTapped() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        
        let signInViewController = SignInViewController()
        
        UIView.transition(with: sceneDelegate.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            sceneDelegate.window?.rootViewController = signInViewController
        })
    }
    
    private func setUpUI() {
        view.addSubview(containerView)
        view.addSubview(colorImageView)
        containerView.addSubview(withLabel)
        containerView.addSubview(colemiLabel)
        containerView.addSubview(togetherLabel)
        containerView.addSubview(observerLabel)
        view.addSubview(circleView)
        view.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            colorImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            colorImageView.widthAnchor.constraint(equalTo: colorImageView.heightAnchor),
            colorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: colorImageView.bottomAnchor, constant: 50),
            containerView.leadingAnchor.constraint(equalTo: withLabel.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: togetherLabel.trailingAnchor),
            containerView.heightAnchor.constraint(equalTo: colemiLabel.heightAnchor, constant: 20),
            
            withLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            withLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            
            colemiLabel.leadingAnchor.constraint(equalTo: withLabel.trailingAnchor, constant: 10),
            colemiLabel.bottomAnchor.constraint(equalTo: withLabel.bottomAnchor),
            
            togetherLabel.leadingAnchor.constraint(equalTo: colemiLabel.trailingAnchor, constant: 10),
            togetherLabel.centerYAnchor.constraint(equalTo: withLabel.centerYAnchor),
            
            observerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            observerLabel.topAnchor.constraint(equalTo: togetherLabel.bottomAnchor, constant: 30),
            
            circleView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.2),
            circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor),
            circleView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            arrowImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            arrowImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            arrowImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            arrowImageView.heightAnchor.constraint(equalTo: arrowImageView.widthAnchor)
        ])
        
        view.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        setUpUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        circleView.layer.cornerRadius = circleView.frame.width / 2
    }
}
