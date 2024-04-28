//
//  WritePostContentViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/11/24.
//

import UIKit

class WritePostContentViewController: UIViewController {
    
    let viewModel = WritePostContentViewModel()
    let colorSimilarityViewController = ColorSimilarityViewController()
    var selectedImage: UIImage?
    let userManager = UserManager.shared
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        return imageView
    }()
    
    lazy var missionColorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "任務顏色"
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }()
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        
        return view
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = ThemeColorProperty.lightColor.getColor()
        textField.font = UIFont(name: FontProperty.GenSenRoundedTW_B.rawValue, size: 40)
        textField.textColor = ThemeColorProperty.darkColor.getColor()
        textField.placeholder = "標題"
        
        return textField
    }()
    
//    func makeSeparatorView() -> UIView {
//        let view = UIView()
//        view.backgroundColor = .black
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }
    
    lazy var photoOptionView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColorProperty.darkColor.getColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        return view
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = ThemeColorProperty.darkColor.getColor()
        textView.layer.cornerRadius = RadiusProperty.radiusThirty.rawValue
        textView.addLineSpacing(lineSpacing: 5)
        textView.textColor = .white
        textView.textContainerInset = .init(top: 25, left: 20, bottom: 25, right: 20)
        textView.font = UIFont(name: FontProperty.GenSenRoundedTW_R.rawValue, size: 16)
        textView.text = "多大埔的傍晚 5 點 23 分，在綠色曠野撒上一抹陽光，春天好像偷偷地來了呢。"
        
        return textView
    }()
    
    lazy var tagTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = ThemeColorProperty.lightColor.getColor()
        textField.placeholder = "#標籤"
        textField.font = UIFont(name: FontProperty.GenSenRoundedTW_R.rawValue, size: 18)
        textField.textAlignment = .right
        textField.textColor = ThemeColorProperty.darkColor.getColor()
        
        return textField
    }()
    
    lazy var photoIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.photoIcon
        return imageView
    }()
    
    lazy var cameraIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.cameraIcon
        return imageView
    }()
    
    lazy var arrowIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.arrorIcon
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(arrowTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    @objc private func arrowTapped(_ sender: UITapGestureRecognizer) {
        guard let image = selectedImage else {
            print("Failed to get selectedImage")
            return
        }
        
        if let imageData = image.jpegData(compressionQuality: 1) {
            colorSimilarityViewController.selectedImageData = imageData
            let imageWidth = image.size.width * image.scale
            let imageHeight = image.size.height * image.scale
            viewModel.uploadImgToFirebase(imageData: imageData, imageSize: CGSize(width: imageWidth, height: imageHeight))
        }
    }
    
//    lazy var postButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Post", for: .normal)
//        button.backgroundColor = ThemeColorProperty.darkColor.getColor()
//        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
//        button.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
//    @objc private func postButtonTapped() {
//        
//        guard let image = selectedImage else {
//            print("Failed to get selectedImage")
//            return
//        }
//        
//        if let imageData = image.jpegData(compressionQuality: 1) {
//            colorSimilarityViewController.selectedImageData = imageData
//            let imageWidth = image.size.width * image.scale
//            let imageHeight = image.size.height * image.scale
//            viewModel.uploadImgToFirebase(imageData: imageData, imageSize: CGSize(width: imageWidth, height: imageHeight))
//        }
//    }
    
    private func setUpUI() {
        
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        view.addSubview(imageView)
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(tagTextField)
        view.addSubview(photoOptionView)
        // view.addSubview(postButton)
        photoOptionView.addSubview(photoIconImageView)
        photoOptionView.addSubview(cameraIconImageView)
        view.addSubview(arrowIconImageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/5),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 3/4),
            
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            titleTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 35),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor, constant: 50),
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 35),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4),
            
            tagTextField.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 100),
            tagTextField.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            tagTextField.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor, constant: -20),
            
            photoOptionView.heightAnchor.constraint(equalToConstant: 80),
            photoOptionView.widthAnchor.constraint(equalToConstant: 200),
            photoOptionView.topAnchor.constraint(equalTo: tagTextField.bottomAnchor, constant: 30),
            photoOptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -40),
            
            photoIconImageView.trailingAnchor.constraint(equalTo: photoOptionView.trailingAnchor, constant: -25),
            photoIconImageView.widthAnchor.constraint(equalToConstant: 50),
            photoIconImageView.heightAnchor.constraint(equalToConstant: 50),
            photoIconImageView.centerYAnchor.constraint(equalTo: photoOptionView.centerYAnchor),
            
            cameraIconImageView.trailingAnchor.constraint(equalTo: photoIconImageView.leadingAnchor, constant: -15),
            cameraIconImageView.widthAnchor.constraint(equalToConstant: 50),
            cameraIconImageView.heightAnchor.constraint(equalToConstant: 50),
            cameraIconImageView.centerYAnchor.constraint(equalTo: photoOptionView.centerYAnchor),
            
//            postButton.heightAnchor.constraint(equalToConstant: 50),
//            postButton.widthAnchor.constraint(equalToConstant: 100),
//            postButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
//            postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            arrowIconImageView.widthAnchor.constraint(equalToConstant: 90),
            arrowIconImageView.heightAnchor.constraint(equalToConstant: 90),
            arrowIconImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            arrowIconImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
        
        if let selectedImage = selectedImage {
            imageView.image = selectedImage
        }
        
        let rotationAngle: CGFloat = -CGFloat.pi * 15 / 180
        photoOptionView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        photoIconImageView.transform = CGAffineTransform(rotationAngle: -rotationAngle)
        cameraIconImageView.transform = CGAffineTransform(rotationAngle: -rotationAngle)
        view.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
}

extension WritePostContentViewController: WritePostContentViewModelDelegate {
    func addDataToFireBase(_ imageUrl: String, imageSize: CGSize) {
        let content = viewModel.makeContentJson(content: Content(imgURL: imageUrl, title: titleTextField.text ?? "", description: descriptionTextView.text, authorName: userManager.name))
        let imageHeight = Double(imageSize.height)
        let imageWidth = Double(imageSize.width)
        
        if let colorString = userManager.selectedHexColor {
            viewModel.addData(authorId: userManager.id, content: content, type: 0, color: colorString, colorSimularity: "", tags: ["Cute"], imageUrl: imageUrl, imageHeight: imageHeight, imageWidth: imageWidth)
        }
        
        colorSimilarityViewController.selectedImage = selectedImage
        colorSimilarityViewController.selectedImageURL = imageUrl
        
        navigationController?.pushViewController(colorSimilarityViewController, animated: true)
    }
}
