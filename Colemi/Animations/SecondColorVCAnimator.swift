//
//  SecondColorVCAnimator.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/2/24.
//

import UIKit

final class SecondColorVCAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.25
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let toVC = transitionContext.viewController(forKey: .to) as? PostDetailViewController,
              let tabBarController = transitionContext.viewController(forKey: .from) as? TabBarController,
              let todayColorVC = tabBarController.lobbyViewController?.children[1],
              let fromVC = todayColorVC.children[1] as? SecondColorViewController,
              let cell = fromVC.selectedCell
        else { return }
        
        cell.isHidden = true
        
        let snapShotView = cell.snapshotView(afterScreenUpdates: false)
        
        guard let snapShotView = snapShotView else { return }
        
        snapShotView.frame = fromVC.postsCollectionView.convert(cell.frame, to: nil)
        
        toVC.view.alpha = 0
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        containerView.addSubview(snapShotView)
        
        toVC.view.layoutIfNeeded()
        toVC.tableView.layoutIfNeeded()
        
        UIView.animate(withDuration: duration) {
            guard let headerView = toVC.headerView else { return }
            snapShotView.frame = headerView.photoImageView.frame
            snapShotView.frame.origin.y += toVC.view.safeAreaLayoutGuide.layoutFrame.origin.y
            fromVC.view.alpha = 0
            tabBarController.tabBar.alpha = 0
            
        } completion: { _ in
            guard let selectedImageView = fromVC.selectedImageView else { return }
            cell.isHidden = false
            
            toVC.view.alpha = 1
            fromVC.view.alpha = 1
            tabBarController.tabBar.alpha = 1
            selectedImageView.isHidden = false
            // toVC.toViewImageView.image = UIImage.image
            snapShotView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
