//
//  AllColorViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/25/24.
//

import UIKit

class AllColorViewController: UIViewController {
    
    let viewModel = LobbyViewModel()
    let userManager = UserManager.shared
    
    private let popAnimator = AllColorsVCPopAnimator()
    private let dismissAnimator = AllColorVCDismissAnimator()
    
    var selectedImageView: UIImageView?
    var selectedCell: LobbyPostCell?
    
    var colorViewWidth: CGFloat = 30
    
    lazy var colorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ColemiIcon")
        return imageView
    }()
    
    lazy var postsCollectionView: UICollectionView = {
        let layout = LobbyLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private func setUpUI() {
        
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        
        view.addSubview(colorImageView)
        view.addSubview(postsCollectionView)
        
        NSLayoutConstraint.activate([
            colorImageView.widthAnchor.constraint(equalToConstant: colorViewWidth),
            colorImageView.heightAnchor.constraint(equalToConstant: colorViewWidth),
            colorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorImageView.topAnchor.constraint(equalTo: view.topAnchor),
            
            postsCollectionView.topAnchor.constraint(equalTo: colorImageView.bottomAnchor,constant: 30),
            postsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            postsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            postsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5)
        ])
    }
    
    // MARK: - For Tests
    
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
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("SignInPage", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func signInButtonTapped() {
        let signInViewController = SignInViewController()
        navigationController?.pushViewController(signInViewController, animated: true)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsCollectionView.dataSource = self
        postsCollectionView.delegate = self
        postsCollectionView.register(LobbyPostCell.self, forCellWithReuseIdentifier: LobbyPostCell.reuseIdentifier)
        
        setUpUI()
        
        // MARK: For Tests
        view.addSubview(chooseColorButton)
        view.addSubview(createUserButton)
        view.addSubview(loginUser1Button)
        view.addSubview(loginUser2Button)
        view.addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            
            createUserButton.heightAnchor.constraint(equalToConstant: 50),
            createUserButton.widthAnchor.constraint(equalToConstant: 100),
            createUserButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            createUserButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            loginUser1Button.heightAnchor.constraint(equalToConstant: 50),
            loginUser1Button.widthAnchor.constraint(equalToConstant: 100),
            loginUser1Button.bottomAnchor.constraint(equalTo: createUserButton.topAnchor, constant: -50),
            loginUser1Button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            loginUser2Button.heightAnchor.constraint(equalToConstant: 50),
            loginUser2Button.widthAnchor.constraint(equalToConstant: 100),
            loginUser2Button.bottomAnchor.constraint(equalTo: createUserButton.topAnchor, constant: -50),
            loginUser2Button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.widthAnchor.constraint(equalToConstant: 100),
            signInButton.bottomAnchor.constraint(equalTo: createUserButton.topAnchor, constant: -50),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            chooseColorButton.heightAnchor.constraint(equalToConstant: 50),
            chooseColorButton.widthAnchor.constraint(equalToConstant: 100),
            chooseColorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            chooseColorButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.readData {
            DispatchQueue.main.async {
                self.postsCollectionView.collectionViewLayout.invalidateLayout()
                self.postsCollectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension AllColorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posts.count
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(viewModel.posts[indexPath.item].imageUrl)
        
        if let cell = collectionView.cellForItem(at: IndexPath(item: indexPath.item, section: 0)) as? LobbyPostCell {
            selectedImageView = cell.imageView
            selectedCell = cell
        }
        
        let postDetailViewController = PostDetailViewController()
        postDetailViewController.viewModel.post = viewModel.posts[indexPath.item]
        
        postDetailViewController.contentJSONString = viewModel.contentJSONString[indexPath.item]
        postDetailViewController.postID = viewModel.posts[indexPath.item].id
        postDetailViewController.authorID = viewModel.posts[indexPath.item].authorId
        postDetailViewController.imageUrl = viewModel.posts[indexPath.item].imageUrl
        postDetailViewController.comments = viewModel.posts[indexPath.item].comments
        postDetailViewController.post = viewModel.posts[indexPath.item]
        
        let navController = UINavigationController(rootViewController: postDetailViewController)
        
//        postDetailViewController.modalPresentationStyle = .custom
//        postDetailViewController.transitioningDelegate = self
//        present(postDetailViewController, animated: true)
        navController.modalPresentationStyle = .custom
        navController.transitioningDelegate = self
        navController.navigationBar.isHidden = true
        present(navController, animated: true)
    }
}

// MARK: - LobbyLayoutDelegate

extension AllColorViewController: LobbyLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        sizeForPhotoAtIndexPath indexPath:IndexPath) -> CGSize {
            
            if indexPath.item < viewModel.posts.count {
                return viewModel.sizes[indexPath.item]
            } else {
                return CGSize(width: 300, height: 400)
            }
        }
}

extension AllColorViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return popAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // popAnimator.presenting = false
        return dismissAnimator
    }
}
