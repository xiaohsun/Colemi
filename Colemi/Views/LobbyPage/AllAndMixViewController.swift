//
//  AllAndMixViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/3/24.
//

import UIKit

protocol AllAndMixViewController: UIViewController {
    var viewModel: LobbyViewModel { get }
    var userManager: UserManager { get }
    
    var selectedImageView: UIImageView? { get set }
    var selectedCell: LobbyPostCell? { get set }
    
    var popAnimator: UIViewControllerAnimatedTransitioning { get }
    var dismissAnimator: UIViewControllerAnimatedTransitioning { get }
    
    var colorViewWidth: CGFloat {get}
    var colorImageView: UIImageView { get }
    var postsCollectionView: UICollectionView { get }
    
    func setUpUI()
}

extension AllAndMixViewController {
    func setUpUI() {
        
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
}
