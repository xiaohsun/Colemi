//
//  ViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/10/24.
//

import UIKit
import Kingfisher

class LobbyViewController: UIViewController {
    
    let viewModel = LobbyViewModel()
    
//    var images: [UIImage] = [UIImage(named: "IMG_0752")!, UIImage(named: "IMG_5333")!, UIImage(named: "IMG_9669")! , UIImage(named: "IMG_6462")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_5333")!, UIImage(named: "IMG_6462")!, UIImage(named: "IMG_5333")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_0752")!]
    
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
    
    lazy var profileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Profile", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func profileButtonTapped() {
        let profileViewController = ProfileViewController()
        navigationController?.pushViewController(profileViewController, animated: true)
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
        view.addSubview(profileButton)
        
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
            chooseColorButton.leadingAnchor.constraint(equalTo: postButton.trailingAnchor, constant: 50),
            
            profileButton.heightAnchor.constraint(equalToConstant: 50),
            profileButton.widthAnchor.constraint(equalToConstant: 100),
            profileButton.bottomAnchor.constraint(equalTo: chooseColorButton.topAnchor, constant: -50),
            profileButton.leadingAnchor.constraint(equalTo: postButton.trailingAnchor, constant: 50)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsCollectionView.dataSource = self
        postsCollectionView.delegate = self
        postsCollectionView.register(LobbyPostCell.self, forCellWithReuseIdentifier: LobbyPostCell.reuseIdentifier)
        
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.readData {
            self.postsCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension LobbyViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LobbyPostCell.reuseIdentifier, for: indexPath) as? LobbyPostCell else {
            print("Having trouble creating cell")
            return UICollectionViewCell()
        }
        
        let post = viewModel.posts[indexPath.item]
        let url = URL(string: post.imageUrl)
        cell.imageView.kf.setImage(with: url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postDetailViewController = PostDetailViewController()
        postDetailViewController.contentJSONString = viewModel.contentJSONString[indexPath.item]
        postDetailViewController.photoImage = viewModel.images[indexPath.item]
        // navigationController?.pushViewController(postDetailViewController, animated: true)
        
        present(postDetailViewController, animated: true)
    }
}

// MARK: - LobbyLayoutDelegate

extension LobbyViewController: LobbyLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        sizeForPhotoAtIndexPath indexPath:IndexPath) -> CGSize {
            
            if indexPath.item < viewModel.images.count {
                return viewModel.images[indexPath.item].size
            } else {
                return CGSize(width: 300, height: 400)
            }
        }
}
