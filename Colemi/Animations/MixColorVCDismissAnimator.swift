//
//  MixColorVCDismissAnimator.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/3/24.
//

import UIKit

final class MixColorVCDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.25
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from) as? PostDetailViewController,
              let tabBarController = transitionContext.viewController(forKey: .to) as? TabBarController,
              let toVC = tabBarController.lobbyViewController?.children[2] as? MixColorViewController,
              let cell = toVC.selectedCell
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
            snapShotView.frame = toVC.postsCollectionView.convert(cell.frame, to: nil)
            
        } completion: { _ in
            
            cell.isHidden = false
            
            snapShotView.removeFromSuperview()
            tabBarController.lobbyViewController?.scrollView.addSubview(toVC.view)
            transitionContext.completeTransition(true)
        }
    }
}
