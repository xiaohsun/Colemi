//
//  ProfileVCDismissAnimator.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/3/24.
//

import UIKit

final class ProfileVCDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var toVC: ProfileViewController
    
    init(toVC: ProfileViewController) {
        self.toVC = toVC
        super.init()
    }
    
    private let duration: TimeInterval = 0.25
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let fromNav = transitionContext.viewController(forKey: .from) as? UINavigationController,
              let fromVC = fromNav.topViewController as? PostDetailViewController,
              let cell = toVC.selectedCell,
              let collectionView = toVC.collectionViewInPostsAndSavesCell
        else { return }
        
        fromVC.view.isHidden = true
        let snapShotView = cell.snapshotView(afterScreenUpdates: false)
        guard let snapShotView = snapShotView else { return }
        
        var frame = (fromVC.headerView?.photoImageView.frame)!
        frame.origin.x += fromVC.xPosition
        frame.origin.y += fromVC.view.safeAreaLayoutGuide.layoutFrame.origin.y + fromVC.yPosition
        snapShotView.frame = frame
        
        containerView.addSubview(snapShotView)
        
        toVC.view.layoutIfNeeded()
        
        UIView.animate(withDuration: duration) {
            snapShotView.frame = collectionView.convert(cell.frame, to: nil)
            
        } completion: { _ in
            
            cell.isHidden = false
            
            snapShotView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
