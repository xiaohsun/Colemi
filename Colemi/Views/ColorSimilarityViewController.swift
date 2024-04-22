//
//  ColorSimilarityViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/14/24.
//

import UIKit

class ColorSimilarityViewController: UIViewController {
    
    var selectedImage: UIImage?
    var selectedImageURL: String?
    var selectedImageData: Data?
    let cloudVisionManager = CloudVisionManager()
    var colors: [Color] = []
    let colorSimilarityViewModel = ColorSimilarityViewModel()
    let userManager = UserManager.shared
    var colorDistance: Double?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        
        if let selectedImage = selectedImage {
            imageView.image = selectedImage
        }
        
        return imageView
    }()
    
    lazy var similarityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "顏色差異為"
        
        return label
    }()
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        
        return view
    }()
    
    lazy var showSimilarityButton: UIButton = {
        let button = UIButton()
        button.setTitle("看相似度", for: .normal)
        button.backgroundColor = ThemeColorProperty.darkColor.getColor()
        button.addTarget(self, action: #selector(showSimilarityButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        
        return button
    }()
    
    @objc func showSimilarityButtonTapped() {
        if let selectedUIColor = userManager.selectedUIColor {
            colorDistance = colorSimilarityViewModel.caculateColorDistance(selectedUIColor: selectedUIColor, colors: colors)
            guard let colorDistance = colorDistance else {
                print("Have trouble print colorDistance")
                return
            }
            print(colorDistance)
            let formattedSimilarity = String(format: "%.2f", colorDistance)
            similarityLabel.text = "顏色差異為\(formattedSimilarity)"
        }
    }
    
    private func setUpUI() {
        view.addSubview(imageView)
        view.addSubview(similarityLabel)
        view.addSubview(colorView)
        view.addSubview(showSimilarityButton)
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        colorView.backgroundColor = userManager.selectedUIColor
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 3/4),
            
            similarityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            similarityLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            
            colorView.topAnchor.constraint(equalTo: similarityLabel.bottomAnchor, constant: 50),
            colorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            colorView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            showSimilarityButton.heightAnchor.constraint(equalToConstant: 50),
            showSimilarityButton.widthAnchor.constraint(equalToConstant: 100),
            showSimilarityButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            showSimilarityButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        cloudVisionManager.delegate = self
        //if let selectedImageData = selectedImageData, let url = selectedImageURL {
            // cloudVisionManager.analyzeImageWithVisionAPI(imageData: selectedImageData, url: url)
        //}
    }
}

extension ColorSimilarityViewController: CloudVisionManagerDelegate {
    func getColorsRGB(colors: [Color]) {
        self.colors = colors
    }
}
