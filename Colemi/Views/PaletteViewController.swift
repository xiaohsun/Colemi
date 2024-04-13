//
//  PaletteViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/13/24.
//

import UIKit

class PaletteViewController: UIViewController {
    
    lazy var findColorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "尋找附近的顏色中"
        label.textColor = .white
        
        return label
    }()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "距離為"
        label.textColor = .white
        
        return label
    }()
    
    lazy var myColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var nearbyColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var mixColorButton: UIButton = {
        let button = UIButton()
        button.setTitle("Mix", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(mixColorButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func mixColorButtonTapped() {
        print("Hi")
    }
    
    private func setUpUI() {
        view.backgroundColor = .darkGray
        view.addSubview(findColorLabel)
        view.addSubview(distanceLabel)
        view.addSubview(myColorView)
        view.addSubview(mixColorButton)
        
        NSLayoutConstraint.activate([
            findColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            findColorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            distanceLabel.topAnchor.constraint(equalTo: findColorLabel.bottomAnchor, constant: 100),
            
            myColorView.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 50),
            myColorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myColorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            myColorView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            mixColorButton.heightAnchor.constraint(equalToConstant: 50),
            mixColorButton.widthAnchor.constraint(equalToConstant: 100),
            mixColorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            mixColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}
