//
//  SecondColorViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/25/24.
//

import UIKit
import Kingfisher
import FirebaseAuth

class SecondColorViewController: UIViewController, TodayColorVCProtocol {
    
    let viewModel = LobbyViewModel()
    var userData: UserManager?
    var loadedBefore: Bool = false
    
    var selectedImageView: UIImageView?
    var selectedCell: LobbyPostCell?
    
    var popAnimator: UIViewControllerAnimatedTransitioning = TodayColorVCPopAnimator(childVCIndex: 1)
    var dismissAnimator: UIViewControllerAnimatedTransitioning = TodayColorVCDismissAnimator(childVCIndex: 1)
    
    lazy var postsCollectionView: UICollectionView = {
        let layout = LobbyLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsCollectionView.dataSource = self
        postsCollectionView.delegate = self
        postsCollectionView.register(LobbyPostCell.self, forCellWithReuseIdentifier: LobbyPostCell.reuseIdentifier)
        
        setUpUI()
    }
    
    func loadData() {
        if !loadedBefore {
            Task.detached {
                await self.viewModel.getSpecificPosts(colorCode: UserManager.shared.colorSetToday.isEmpty ? "#8BAEAA" : UserManager.shared.colorSetToday[1]) {
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

extension SecondColorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
            
            postDetailViewController.contentJSONString = viewModel.contentJSONString[indexPath.item]
            postDetailViewController.postID = viewModel.posts[indexPath.item].id
            postDetailViewController.viewModel.authorID = viewModel.posts[indexPath.item].authorId
            postDetailViewController.imageUrl = viewModel.posts[indexPath.item].imageUrl
            
            let navController = UINavigationController(rootViewController: postDetailViewController)
            
            navController.modalPresentationStyle = .custom
            navController.transitioningDelegate = self
            navController.navigationBar.isHidden = true
            present(navController, animated: true)
        }
    }
}

// MARK: - LobbyLayoutDelegate

extension SecondColorViewController: LobbyLayoutDelegate {
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

extension SecondColorViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return popAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimator
    }
}



// MARK: - 留下來備份不繼承 TodayColorVCProtocol 的

//class SecondColorViewController: UIViewController {
//    let viewModel = LobbyViewModel()
//    let userManager = UserManager.shared
//    var loadedBefore: Bool = false
//    
//    var selectedImageView: UIImageView?
//    var selectedCell: LobbyPostCell?
//    private let popAnimator = SecondColorVCAnimator()
//    private let dismissAnimator = SecondColorVCDismissAnimator()
//    
//    lazy var postsCollectionView: UICollectionView = {
//        let layout = LobbyLayout()
//        layout.delegate = self
//        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.backgroundColor = ThemeColorProperty.lightColor.getColor()
//        collectionView.showsVerticalScrollIndicator = false
//        
//        return collectionView
//    }()
//    
//    private func setUpUI() {
//        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
//        
//        view.addSubview(postsCollectionView)
//        
//        NSLayoutConstraint.activate([
//            postsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
//            postsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
//            postsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            postsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5)
//        ])
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        postsCollectionView.dataSource = self
//        postsCollectionView.delegate = self
//        postsCollectionView.register(LobbyPostCell.self, forCellWithReuseIdentifier: LobbyPostCell.reuseIdentifier)
//        
//        setUpUI()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//
////        viewModel.readData {
////            DispatchQueue.main.async {
////                self.postsCollectionView.collectionViewLayout.invalidateLayout()
////                self.postsCollectionView.reloadData()
////            }
////        }
//    }
//    
//    func loadData() {
//        if !loadedBefore {
//            Task.detached {
//                await self.viewModel.getSpecificPosts(colorCode: "#8BAEAA") {
//                    DispatchQueue.main.async {
//                        self.postsCollectionView.collectionViewLayout.invalidateLayout()
//                        self.postsCollectionView.reloadData()
//                    }
//                }
//            }
//        }
//    }
//}
//
//// MARK: - UICollectionViewDataSource
//
//extension SecondColorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.posts.count
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LobbyPostCell.reuseIdentifier, for: indexPath) as? LobbyPostCell else {
//            print("Having trouble creating cell")
//            return UICollectionViewCell()
//        }
//        
//        let post = viewModel.posts[indexPath.item]
//        let url = URL(string: post.imageUrl)
//        cell.imageView.kf.setImage(with: url)
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        if let cell = collectionView.cellForItem(at: IndexPath(item: indexPath.item, section: 0)) as? LobbyPostCell {
//            selectedImageView = cell.imageView
//            selectedCell = cell
//        }
//        
//        let postDetailViewController = PostDetailViewController()
//        postDetailViewController.viewModel.post = viewModel.posts[indexPath.item]
//        
//        postDetailViewController.contentJSONString = viewModel.contentJSONString[indexPath.item]
//        postDetailViewController.postID = viewModel.posts[indexPath.item].id
//        postDetailViewController.authorID = viewModel.posts[indexPath.item].authorId
//        postDetailViewController.imageUrl = viewModel.posts[indexPath.item].imageUrl
//        postDetailViewController.comments = viewModel.posts[indexPath.item].comments
//        postDetailViewController.post = viewModel.posts[indexPath.item]
//        
//        postDetailViewController.modalPresentationStyle = .custom
//        postDetailViewController.transitioningDelegate = self
//        
//        present(postDetailViewController, animated: true)
//    }
//}
//
//// MARK: - LobbyLayoutDelegate
//
//extension SecondColorViewController: LobbyLayoutDelegate {
//    func collectionView(
//        _ collectionView: UICollectionView,
//        sizeForPhotoAtIndexPath indexPath:IndexPath) -> CGSize {
//            
//            if indexPath.item < viewModel.posts.count {
//                return viewModel.sizes[indexPath.item]
//            } else {
//                return CGSize(width: 300, height: 400)
//            }
//        }
//}
//
//extension SecondColorViewController: UIViewControllerTransitioningDelegate {
//    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return popAnimator
//    }
//    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return dismissAnimator
//    }
//}
