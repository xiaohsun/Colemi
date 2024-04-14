//
//  ColorSimilarityViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/14/24.
//

import UIKit

class ColorSimilarityViewController: UIViewController {
    
    var selectedImage: UIImage?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        
        return imageView
    }()
    
    lazy var similarityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "相似度為"
        
        return label
    }()
    
    private func setUpUI() {
        view.addSubview(imageView)
        view.addSubview(similarityLabel)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 3/4),
            
            similarityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            similarityLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        ])
        
        if let selectedImage = selectedImage {
            imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}
