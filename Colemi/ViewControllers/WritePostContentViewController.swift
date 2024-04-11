//
//  WritePostContentViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/11/24.
//

import UIKit

class WritePostContentViewController: UIViewController {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "標題"
        // label.font = UIFont(name: <#T##String#>, size: <#T##CGFloat#>)
        // label.textColor = UIColor(named: <#T##String#>)
        
        return label
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        // textField.textColor = UIColor(named: <#T##String#>)
        // textField.layer.borderColor = UIColor(named: <#T##String#>).cgColor
        // textField.layer.borderWidth = 1
        textField.backgroundColor = .white
        // textField.isEnabled = false
        // textField.text = "<#1#>"
        textField.placeholder = "請填寫"
        // textField.textColor = UIColor(named: <#T##String#>)
        // textField.keyboardType = .numberPad
        // textField.textAlignment = .center
        
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
        // label.font = UIFont(name: <#T##String#>, size: <#T##CGFloat#>)
        // label.textColor = UIColor(named: <#T##String#>)
        
        return label
    }()
    
    lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .black
        return textView
    }()
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "標籤"
        // label.font = UIFont(name: <#T##String#>, size: <#T##CGFloat#>)
        // label.textColor = UIColor(named: <#T##String#>)
        
        return label
    }()
    
    lazy var tagTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        // textField.textColor = UIColor(named: <#T##String#>)
        // textField.layer.borderColor = UIColor(named: <#T##String#>).cgColor
        // textField.layer.borderWidth = 1
        textField.backgroundColor = .white
        // textField.isEnabled = false
        // textField.text = "<#1#>"
        textField.placeholder = "請填寫"
        // textField.textColor = UIColor(named: <#T##String#>)
        // textField.keyboardType = .numberPad
        // textField.textAlignment = .center
        
        return textField
    }()
    
    lazy var postButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func postButtonTapped() {
        print("Hi")
    }
    
    private func setUpUI() {
        
        let separatorView1 = makeSeparatorView()
        let separatorView2 = makeSeparatorView()
        let separatorView3 = makeSeparatorView()
            
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(separatorView1)
        view.addSubview(contentLabel)
        view.addSubview(contentTextView)
        view.addSubview(separatorView2)
        view.addSubview(tagLabel)
        view.addSubview(tagTextField)
        view.addSubview(separatorView3)
        view.addSubview(postButton)
        
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
            
            contentTextView.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
            contentTextView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 20),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/9),
            
            separatorView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            separatorView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            separatorView2.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 20),
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}
