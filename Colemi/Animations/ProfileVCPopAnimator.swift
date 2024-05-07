//
//  ProfileVCPopAnimator.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/3/24.
//

import UIKit

final class ProfileVCPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var fromVC: ProfileViewController
    
    init(fromVC: ProfileViewController) {
        self.fromVC = fromVC
        super.init()
    }
    
    private let duration: TimeInterval = 0.25
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let toNav = transitionContext.viewController(forKey: .to) as? UINavigationController,
              let toVC = toNav.topViewController as? PostDetailViewController,
              let cell = fromVC.selectedCell,
              let collectionView = fromVC.collectionViewInPostsAndSavesCell
        else { return }
        
        cell.isHidden = true
        
        let snapShotView = cell.snapshotView(afterScreenUpdates: false)
        
        guard let snapShotView = snapShotView else { return }
        
        snapShotView.frame = collectionView.convert(cell.frame, to: nil)
        
        toVC.view.alpha = 0
        
        containerView.insertSubview(toNav.view, belowSubview: fromVC.view)
        containerView.addSubview(snapShotView)
        
        toVC.view.layoutIfNeeded()
        toVC.tableView.layoutIfNeeded()
        
        UIView.animate(withDuration: duration) {
            guard let headerView = toVC.headerView else { return }
            snapShotView.frame = headerView.photoImageView.frame
            snapShotView.frame.origin.y += toNav.view.safeAreaLayoutGuide.layoutFrame.origin.y
            //fromVC.view.alpha = 0
            // tabBarController.tabBar.alpha = 0
            
        } completion: { _ in
            guard let selectedImageView = self.fromVC.selectedImageView else { return }
            cell.isHidden = false
            
            toVC.view.alpha = 1
            // fromVC.view.alpha = 1
            // tabBarController.tabBar.alpha = 1
            selectedImageView.isHidden = false
            // toVC.toViewImageView.image = UIImage.image
            snapShotView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
