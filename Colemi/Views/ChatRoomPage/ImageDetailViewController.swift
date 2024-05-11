//
//  ImageDetailViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/11/24.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    var imageViewHeightCons: NSLayoutConstraint?
    
    lazy var imageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
       
        return imageView
    }()
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.addSubview(imageView)
        
        imageViewHeightCons = imageView.heightAnchor.constraint(equalToConstant: 400)
        imageViewHeightCons?.isActive = true
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
