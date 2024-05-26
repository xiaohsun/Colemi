//
//  AllColorViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/25/24.
//

import UIKit
import Kingfisher
import FirebaseAuth

class AllColorViewController: UIViewController, AllAndMixVCProtocol {
    
    var popAnimator: UIViewControllerAnimatedTransitioning = AllandMixColorsVCPopAnimator(childVCIndex: 0)
    var dismissAnimator: UIViewControllerAnimatedTransitioning = AllandMixColorVCDismissAnimator(childVCIndex: 0)
    
    let viewModel = LobbyViewModel()
    let userManager = UserManager.shared
    
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
        setLongPressGes(collectionView: collectionView)
        
        return collectionView
    }()
    
    private func setLongPressGes(collectionView: UICollectionView) {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let positionInCollectionView = gestureRecognizer.location(in: postsCollectionView)
            let positionInScreen = gestureRecognizer.location(in: view)
            if let index = postsCollectionView.indexPathForItem(at: positionInCollectionView) {
                
                let mainPageOverLayPopUp = MainPageOverLayPopUp()
                mainPageOverLayPopUp.gestureYPosision = positionInScreen.y
                mainPageOverLayPopUp.gestureXPosision = positionInScreen.x
                mainPageOverLayPopUp.appear(sender: self)
            }
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsCollectionView.dataSource = self
        postsCollectionView.delegate = self
        postsCollectionView.register(LobbyPostCell.self, forCellWithReuseIdentifier: LobbyPostCell.reuseIdentifier)
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.userManager = UserManager.shared
        
        if viewModel.userManager.blocking.isEmpty {
            viewModel.readData { [weak self] in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.postsCollectionView.collectionViewLayout.invalidateLayout()
                    self.postsCollectionView.reloadData()
                }
            }
        } else {
            Task {
                await viewModel.getNotInPosts { [weak self] in
                    guard let self else { return }
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
        cell.imageView.kf.setImage(with: url, options: [
            .transition(ImageTransition.fade(0.3)),
            .forceTransition,
            .keepCurrentImageWhileLoading
      ])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(viewModel.posts[indexPath.item].imageUrl)
        
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
