//
//  ViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/10/24.
//

import UIKit

class LobbyViewController: UIViewController {
    
    let viewModel = LobbyViewModel()
    
    var images: [UIImage] = [UIImage(named: "IMG_0752")!, UIImage(named: "IMG_5333")!, UIImage(named: "IMG_9669")! , UIImage(named: "IMG_6462")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_5333")!, UIImage(named: "IMG_6462")!, UIImage(named: "IMG_5333")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_0752")!]
    
    lazy var postButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(postBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func postBtnTapped() {
        let pickPhotoViewController = PickPhotoViewController()
        navigationController?.pushViewController(pickPhotoViewController, animated: true)
    }
    
    lazy var paletteButton: UIButton = {
        let button = UIButton()
        button.setTitle("調色", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(paletteBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func paletteBtnTapped() {
        let paletteViewController = PaletteViewController()
        navigationController?.pushViewController(paletteViewController, animated: true)
    }
    
    lazy var chooseColorButton: UIButton = {
        let button = UIButton()
        button.setTitle("Color", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(chooseColorBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func chooseColorBtnTapped() {
        let chooseColorViewController = ChooseColorViewController()
        navigationController?.pushViewController(chooseColorViewController, animated: true)
    }
    
    lazy var postsCollectionView: UICollectionView = {
        let layout = LobbyLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    private func setUpUI() {
        view.addSubview(postsCollectionView)
        view.addSubview(postButton)
        view.addSubview(chooseColorButton)
        view.addSubview(paletteButton)
        
        NSLayoutConstraint.activate([
            postsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            postsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            postsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            paletteButton.heightAnchor.constraint(equalToConstant: 50),
            paletteButton.widthAnchor.constraint(equalToConstant: 100),
            paletteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            paletteButton.trailingAnchor.constraint(equalTo: postButton.leadingAnchor, constant: -50),
            
            postButton.heightAnchor.constraint(equalToConstant: 50),
            postButton.widthAnchor.constraint(equalToConstant: 100),
            postButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            chooseColorButton.heightAnchor.constraint(equalToConstant: 50),
            chooseColorButton.widthAnchor.constraint(equalToConstant: 100),
            chooseColorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            chooseColorButton.leadingAnchor.constraint(equalTo: postButton.trailingAnchor, constant: 50)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postsCollectionView.dataSource = self
        postsCollectionView.register(LobbyPostCell.self, forCellWithReuseIdentifier: LobbyPostCell.reuseIdentifier)
        
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postsCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension LobbyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LobbyPostCell.reuseIdentifier, for: indexPath) as? LobbyPostCell else {
            print("Having trouble creating cell")
            return UICollectionViewCell()
        }
        
        cell.imageView.image = images[indexPath.item]
        return cell
    }
}

// MARK: - LobbyLayoutDelegate

extension LobbyViewController: LobbyLayoutDelegate {
  func collectionView(
      _ collectionView: UICollectionView,
      sizeForPhotoAtIndexPath indexPath:IndexPath) -> CGSize {
          return images[indexPath.item].size
  }
}
