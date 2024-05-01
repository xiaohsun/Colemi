//
//  DismissAnimator.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/26/24.
//

import UIKit

final class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.25
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from) as? PostDetailViewController,
              let tabBarController = transitionContext.viewController(forKey: .to) as? TabBarController
        else { return }
        
        let toVC = tabBarController.lobbyViewController?.children[0] as! AllColorViewController
        
        
        let cell = toVC.selectedCell
        // cell?.isHidden = true
        fromVC.view.isHidden = true
        
        // let snapShotView = fromVC.headerView?.photoImageView.snapshotView(afterScreenUpdates: false)
        // let snapShotView = UIImageView(image: fromVC.headerView?.photoImageView.image)
        let snapShotView = cell!.snapshotView(afterScreenUpdates: false)
        guard let snapShotView = snapShotView else { return }
        
        // snapShotView.frame = (fromVC.headerView?.photoImageView.frame)!
        // snapShotView.frame.origin.y += fromVC.view.safeAreaLayoutGuide.layoutFrame.origin.y
        
        var frame = (fromVC.headerView?.photoImageView.frame)!
        frame.origin.x += fromVC.xPosition
        frame.origin.y += fromVC.view.safeAreaLayoutGuide.layoutFrame.origin.y + fromVC.yPosition
        snapShotView.frame = frame
        
        // toVC.view.frame =
        // toVC.view.alpha = 0
        
        // containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        containerView.addSubview(snapShotView)
        
        toVC.view.layoutIfNeeded()
        
        UIView.animate(withDuration: duration) {
            snapShotView.frame = toVC.postsCollectionView.convert(cell!.frame, to: nil)
            // toVC.view.alpha = 1
            
        } completion: { _ in
            
            cell?.isHidden = false
           
            // fromVC.selectedImageView!.isHidden = false
            // toVC.toViewImageView.image = UIImage.image
            snapShotView.removeFromSuperview()
            tabBarController.lobbyViewController!.scrollView.addSubview(toVC.view)
            transitionContext.completeTransition(true)
        }
    }
}
