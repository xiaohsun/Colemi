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
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "標題"
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = ThemeColorProperty.lightColor.getColor()
        textField.placeholder = "請填寫"
        
        return textField
    }()
    
    func makeSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "內文"
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        textView.layer.borderWidth = 2
        textView.layer.borderColor = ThemeColorProperty.darkColor.getColor().cgColor
        textView.text = "哈哈哈"
        return textView
    }()
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "標籤"
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }()
    
    lazy var tagTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = ThemeColorProperty.lightColor.getColor()
        textField.placeholder = "請填寫"
        
        return textField
    }()
    
    lazy var postButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.backgroundColor = ThemeColorProperty.darkColor.getColor()
        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        button.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func postButtonTapped() {
        
        guard let image = selectedImage else {
            print("Failed to get selectedImage")
            return
        }
        
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            colorSimilarityViewController.selectedImageData = imageData
            viewModel.uploadImgToFirebase(imageData: imageData, imageSize: image.size)
        }
    }
    
    private func setUpUI() {
        
        let separatorView1 = makeSeparatorView()
        let separatorView2 = makeSeparatorView()
        let separatorView3 = makeSeparatorView()
        
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(separatorView1)
        view.addSubview(contentLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(separatorView2)
        view.addSubview(tagLabel)
        view.addSubview(tagTextField)
        view.addSubview(separatorView3)
        view.addSubview(postButton)
        
        tabBarController?.tabBar.isHidden = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 3/4),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            
            titleTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            separatorView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            separatorView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            separatorView1.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            separatorView1.heightAnchor.constraint(equalToConstant: 1),
            
            contentLabel.leadingAnchor.constraint(equalTo: separatorView1.leadingAnchor),
            contentLabel.topAnchor.constraint(equalTo: separatorView1.bottomAnchor, constant: 20),
            
            descriptionTextView.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/9),
            
            separatorView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            separatorView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            separatorView2.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            separatorView2.heightAnchor.constraint(equalToConstant: 1),
            
            tagLabel.leadingAnchor.constraint(equalTo: separatorView2.leadingAnchor),
            tagLabel.topAnchor.constraint(equalTo: separatorView2.bottomAnchor, constant: 20),
            
            tagTextField.leadingAnchor.constraint(equalTo: tagLabel.leadingAnchor),
            tagTextField.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 20),
            tagTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            separatorView3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            separatorView3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            separatorView3.topAnchor.constraint(equalTo: tagTextField.bottomAnchor, constant: 20),
            separatorView3.heightAnchor.constraint(equalToConstant: 1),
            
            postButton.heightAnchor.constraint(equalToConstant: 50),
            postButton.widthAnchor.constraint(equalToConstant: 100),
            postButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        if let selectedImage = selectedImage {
            imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        viewModel.delegate = self
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
