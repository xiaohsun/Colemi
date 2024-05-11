//
//  ChatRoomVCDismissAnimator.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/11/24.
//

import UIKit

final class ChatRoomVCDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var toNav: UINavigationController
    
    init(toNav: UINavigationController) {
        self.toNav = toNav
        super.init()
    }
    
    private let duration: TimeInterval = 0.25
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard
              let fromVC = transitionContext.viewController(forKey: .from) as? ImageDetailViewController,
              // let tabBarController = transitionContext.viewController(forKey: .to) as? TabBarController,
              // let toNav = tabBarController.chatRoomsNavController,
              let toVC = toNav.topViewController as? ChatRoomViewController,
              let cell = toVC.tappedCell,
              let tappedImageView = toVC.tappedImageView
        else { return }
        
        tappedImageView.isHidden = true
        
        let snapShotView = tappedImageView.snapshotView(afterScreenUpdates: false)
        
        guard let snapShotView = snapShotView else { return }
        
        snapShotView.frame = fromVC.imageView.frame
        
        fromVC.view.alpha = 0
        
        containerView.addSubview(snapShotView)
        
        UIView.animate(withDuration: duration) {
            snapShotView.frame = cell.convert(tappedImageView.frame, to: nil)
            
        } completion: { _ in
            
            tappedImageView.isHidden = false
            
            toVC.view.alpha = 1
            snapShotView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
