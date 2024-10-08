//
//  MixColorViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/25/24.
//

import UIKit
import Kingfisher
import FirebaseAuth

class MixColorViewController: UIViewController, AllAndMixVCProtocol {
    
    var popAnimator: UIViewControllerAnimatedTransitioning = AllandMixColorsVCPopAnimator(childVCIndex: 2)
    var dismissAnimator: UIViewControllerAnimatedTransitioning = AllandMixColorVCDismissAnimator(childVCIndex: 2)
    
    let viewModel = LobbyViewModel()
    let userManager = UserManager.shared
    
    var selectedImageView: UIImageView?
    var selectedCell: LobbyPostCell?
    
    var colorViewWidth: CGFloat = 25
    
    lazy var colorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.image = UIImage(systemName: "questionmark")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = ThemeColorProperty.darkColor.getColor()
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
    
    lazy var ctaLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 24)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = "混色後再來看看吧"
        
        return label
    }()
    
    private func setCtaLabel() {
        view.addSubview(ctaLabel)
        
        NSLayoutConstraint.activate([
            ctaLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ctaLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75)
        ])
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsCollectionView.dataSource = self
        postsCollectionView.delegate = self
        postsCollectionView.register(LobbyPostCell.self, forCellWithReuseIdentifier: LobbyPostCell.reuseIdentifier)
        
        setupUI()
        setCtaLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.userManager.mixColorToday != "" {
            ctaLabel.isHidden = true
        }
        
        if userManager.mixColorToday != "" {
            colorImageView.backgroundColor = UIColor(hex: userManager.mixColorToday)
            colorImageView.image = nil
            Task.detached { [weak self] in
                guard let self else { return }
                await self.viewModel.getSpecificPosts(colorCode: self.userManager.mixColorToday) {
                    DispatchQueue.main.async {
                        self.postsCollectionView.collectionViewLayout.invalidateLayout()
                        self.postsCollectionView.reloadData()
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MixColorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        cell.imageView.kf.setImage(with: url, options: [
            .transition(ImageTransition.fade(0.3)),
            .forceTransition,
            .keepCurrentImageWhileLoading
      ])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if Auth.auth().currentUser == nil {
            CustomFunc.needLoginAlert(title: "需要登入", message: "登入才能使用此功能唷", vc: self, actionHandler: nil )
            return
            
        } else {
        if let cell = collectionView.cellForItem(at: IndexPath(item: indexPath.item, section: 0)) as? LobbyPostCell {
            selectedImageView = cell.imageView
            selectedCell = cell
        }
        
        let postDetailViewController = PostDetailViewController()
        postDetailViewController.viewModel.post = viewModel.posts[indexPath.item]
        postDetailViewController.viewModel.contentJSONString = viewModel.contentJSONString[indexPath.item]
            postDetailViewController.viewModel.postID = viewModel.posts[indexPath.item].id
        postDetailViewController.viewModel.authorID = viewModel.posts[indexPath.item].authorId
            postDetailViewController.viewModel.imageUrl = viewModel.posts[indexPath.item].imageUrl
        
        let navController = UINavigationController(rootViewController: postDetailViewController)
        
        navController.modalPresentationStyle = .custom
        navController.transitioningDelegate = self
        navController.navigationBar.isHidden = true
        present(navController, animated: true)
        }
    }
}

// MARK: - LobbyLayoutDelegate

extension MixColorViewController: LobbyLayoutDelegate {
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


extension MixColorViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return popAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimator
    }
}
