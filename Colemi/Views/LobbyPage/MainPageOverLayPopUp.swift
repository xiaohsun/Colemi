//
//  MainPageOverLayPopUp.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/5/24.
//

import UIKit

class MainPageOverLayPopUp: UIViewController {
    
    var containerViewTopCons: NSLayoutConstraint?
    var containerViewLeadingCons: NSLayoutConstraint?
    var containerViewWidthCons: NSLayoutConstraint?
    var containerViewHeightCons: NSLayoutConstraint?
    var fromMainPage: Bool = false
    var gestureYPosision: CGFloat = 0.0
    var gestureXPosision: CGFloat = 0.0
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showReportAlert))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        view.alpha = 0
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ThemeColorProperty.darkColor.getColor()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showReportAlert))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    @objc private func dismissPopUp() {
        hide()
    }
    
    private func setUpUI() {
        view.backgroundColor = .clear
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(iconImageView)
        
        containerViewTopCons = containerView.topAnchor.constraint(equalTo: view.topAnchor)
        containerViewTopCons?.isActive = true
        
        containerViewLeadingCons = containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        containerViewLeadingCons?.isActive = true
        
        containerViewWidthCons = containerView.heightAnchor.constraint(equalToConstant: 10)
        containerViewHeightCons = containerView.widthAnchor.constraint(equalToConstant: 10)
        containerViewWidthCons?.isActive = true
        containerViewHeightCons?.isActive = true
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            iconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            iconImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        backgroundAddGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        containerView.layer.cornerRadius = containerView.frame.width / 2
    }
    
    private func backgroundAddGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.isUserInteractionEnabled = true
    }
    
    func appear(sender: UIViewController) {
        self.modalPresentationStyle = .overFullScreen
        
        
        
        sender.present(self, animated: false) {
            
            self.containerViewTopCons?.constant = self.gestureYPosision + 150
            self.containerViewLeadingCons?.constant = self.gestureXPosision
            self.view.layoutIfNeeded()
            
            self.containerViewWidthCons?.constant = 45
            self.containerViewHeightCons?.constant = 45
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                self.view.layoutIfNeeded()
                self.backgroundView.alpha = 1
                self.containerView.alpha = 1
            }
        }
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.1) {
            self.backgroundView.alpha = 0
            self.containerView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
    
    @objc private func showReportAlert() {
        let alert1 = UIAlertController(title: "檢舉貼文", message: "若這篇文章違反社群守則，我們將會進行處置。", preferredStyle: .alert)
        let alert2 = UIAlertController(title: "已收到檢舉", message: "謝謝你，我們將會進行查證", preferredStyle: .alert)
        
        alert1.addAction(UIAlertAction(title: "檢舉", style: .default, handler: { _ in
            alert2.addAction(UIAlertAction(title: "好的", style: .default, handler: { _ in
                self.hide()
            }))
            self.present(alert2, animated: true)
        }))

        alert1.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            self.hide()
        }))
        present(alert1, animated: true, completion: nil)
    }
}
