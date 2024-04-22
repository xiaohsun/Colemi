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
    let userManager = UserManager.shared
    
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
    
    lazy var createUserButton: UIButton = {
        let button = UIButton()
        button.setTitle("CreateUser", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(createUserButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func createUserButtonTapped() {
        viewModel.createUser()
    }
    
    lazy var loginUser1Button: UIButton = {
        let button = UIButton()
        button.setTitle("LoginUser1", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(loginUser1ButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func loginUser1ButtonTapped() {
        //        await viewModel.loginUserOne { user in
        //            print(user)
        //        }
        Task {
            await viewModel.loginUserOne { [weak self] user in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let user = user {
                        self.userManager.avatarPhoto = user.avatarPhoto
                        self.userManager.chatRooms = user.chatRooms
                        self.userManager.description = user.description
                        self.userManager.followers = user.followers
                        self.userManager.following = user.following
                        self.userManager.id = user.id
                        self.userManager.lastestLoginTime = user.lastestLoginTime
                        self.userManager.likes = user.likes
                        self.userManager.name = user.name
                        self.userManager.colorToday = user.colorToday
                        self.userManager.savedPosts = user.savedPosts
                        self.userManager.signUpTime = user.signUpTime
                        self.userManager.posts = user.posts
                        print(self.userManager.name)
                    }
                }
            }
        }
    }
    
    lazy var loginUser2Button: UIButton = {
        let button = UIButton()
        button.setTitle("LoginUser2", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(loginUser2ButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func loginUser2ButtonTapped() {
        Task {
            await viewModel.loginUserTwo { [weak self] user in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let user = user {
                        self.userManager.avatarPhoto = user.avatarPhoto
                        self.userManager.chatRooms = user.chatRooms
                        self.userManager.description = user.description
                        self.userManager.followers = user.followers
                        self.userManager.following = user.following
                        self.userManager.id = user.id
                        self.userManager.lastestLoginTime = user.lastestLoginTime
                        self.userManager.likes = user.likes
                        self.userManager.name = user.name
                        self.userManager.colorToday = user.colorToday
                        self.userManager.savedPosts = user.savedPosts
                        self.userManager.signUpTime = user.signUpTime
                        self.userManager.posts = user.posts
                        print(self.userManager.name)
                    }
                }
            }
        }
    }
    
    lazy var chatRoomButton: UIButton = {
        let button = UIButton()
        button.setTitle("ChatRoom", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(chatRoomButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func chatRoomButtonTapped() {
        let chatRoomsViewController = ChatRoomsViewController()
        navigationController?.pushViewController(chatRoomsViewController, animated: true)
    }
    
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
        view.addSubview(createUserButton)
        view.addSubview(chatRoomButton)
        view.addSubview(loginUser1Button)
        view.addSubview(loginUser2Button)
        
        NSLayoutConstraint.activate([
            postsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            postsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            postsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            createUserButton.heightAnchor.constraint(equalToConstant: 50),
            createUserButton.widthAnchor.constraint(equalToConstant: 100),
            createUserButton.bottomAnchor.constraint(equalTo: paletteButton.topAnchor, constant: -50),
            createUserButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            loginUser1Button.heightAnchor.constraint(equalToConstant: 50),
            loginUser1Button.widthAnchor.constraint(equalToConstant: 100),
            loginUser1Button.bottomAnchor.constraint(equalTo: createUserButton.topAnchor, constant: -50),
            loginUser1Button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            loginUser2Button.heightAnchor.constraint(equalToConstant: 50),
            loginUser2Button.widthAnchor.constraint(equalToConstant: 100),
            loginUser2Button.bottomAnchor.constraint(equalTo: createUserButton.topAnchor, constant: -50),
            loginUser2Button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
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
            profileButton.leadingAnchor.constraint(equalTo: postButton.trailingAnchor, constant: 50),
            
            chatRoomButton.heightAnchor.constraint(equalToConstant: 50),
            chatRoomButton.widthAnchor.constraint(equalToConstant: 100),
            chatRoomButton.bottomAnchor.constraint(equalTo: chooseColorButton.topAnchor, constant: -50),
            chatRoomButton.leadingAnchor.constraint(equalTo: postButton.leadingAnchor)
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
            // self.setUpUI()
            // self.postsCollectionView.reloadData()
            DispatchQueue.main.async {
                self.postsCollectionView.collectionViewLayout.invalidateLayout()
                self.postsCollectionView.reloadData()
                // self.postsCollectionView.reloadSections([0])
            }
            
            // self.postsCollectionView.layoutIfNeeded()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension LobbyViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posts.count
        // 這裡是 3 次
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LobbyPostCell.reuseIdentifier, for: indexPath) as? LobbyPostCell else {
            print("Having trouble creating cell")
            return UICollectionViewCell()
        }
        
        let post = viewModel.posts[indexPath.item]
        let url = URL(string: post.imageUrl)
        cell.imageView.kf.setImage(with: url)
        //cell.imageView.image = viewModel.images[indexPath.item]
        // 但是這裡只執行 2 次
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(viewModel.posts[indexPath.item].imageUrl)
        let postDetailViewController = PostDetailViewController()
        postDetailViewController.contentJSONString = viewModel.contentJSONString[indexPath.item]
        // postDetailViewController.photoImage = viewModel.images[indexPath.item]
        postDetailViewController.postID = viewModel.posts[indexPath.item].id
        postDetailViewController.authorID = viewModel.posts[indexPath.item].authorId
        postDetailViewController.imageUrl = viewModel.posts[indexPath.item].imageUrl
        // navigationController?.pushViewController(postDetailViewController, animated: true)
        // 這裡的 images 的 count 少 contentJSONString 一個
        // print(indexPath.item)
        
        present(postDetailViewController, animated: true)
    }
}

// MARK: - LobbyLayoutDelegate

extension LobbyViewController: LobbyLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        sizeForPhotoAtIndexPath indexPath:IndexPath) -> CGSize {
            
            if indexPath.item < viewModel.posts.count {
                // return viewModel.images[indexPath.item].size
                return viewModel.sizes[indexPath.item]
            } else {
                return CGSize(width: 300, height: 400)
            }
        }
}
