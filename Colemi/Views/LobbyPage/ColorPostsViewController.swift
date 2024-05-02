//
//  ColorPostsViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/2/24.
//

import UIKit

protocol ColorPostsViewController: UIViewController {
    var viewModel: LobbyViewModel { get }
    var userManager: UserManager { get }
    var loadedBefore: Bool { get set }
    var selectedImageView: UIImageView? { get set }
    var selectedCell: LobbyPostCell? { get set }
    var popAnimator: UIViewControllerAnimatedTransitioning { get }
    var dismissAnimator: UIViewControllerAnimatedTransitioning { get }
    
    var postsCollectionView: UICollectionView { get }
    
    func setUpUI()
}

extension ColorPostsViewController {
    func setUpUI() {
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        
        view.addSubview(postsCollectionView)
        
        NSLayoutConstraint.activate([
            postsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            postsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            postsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            postsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5)
        ])
    }
}
