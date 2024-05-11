//
//  ChatRoomVCDismissAnimator.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/11/24.
//

import UIKit

final class ChatRoomVCDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
//    var toVC: ChatRoomViewController
//    
//    init(toVC: ChatRoomViewController) {
//        self.toVC = toVC
//        super.init()
//    }
    
    private let duration: TimeInterval = 0.25
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard
              let fromVC = transitionContext.viewController(forKey: .from) as? ImageDetailViewController,
              let tabBarController = transitionContext.viewController(forKey: .to) as? TabBarController,
            let toNav = tabBarController.chatRoomsNavController,
            let toVC = toNav.topViewController as? ChatRoomViewController,
              let cell = toVC.tappedCell,
              let tappedImageView = toVC.tappedImageView
        else { return }
        
        tappedImageView.isHidden = true
        
        
        // let snapShotView = fromVC.imageView.snapshotView(afterScreenUpdates: false)
        let snapShotView = tappedImageView.snapshotView(afterScreenUpdates: false)
        
        guard let snapShotView = snapShotView else { return }
        
        snapShotView.frame = fromVC.imageView.frame
        
        fromVC.view.alpha = 0
        
        containerView.insertSubview(toNav.view, belowSubview: fromVC.view)
        // containerView.addSubview(toVC.view)
        // containerView.addSubview(tabBarController.view)
        containerView.addSubview(snapShotView)
        
        UIView.animate(withDuration: duration) {
            snapShotView.frame = cell.convert(tappedImageView.frame, to: nil)
            
        } completion: { _ in
            
            tappedImageView.isHidden = false
            
            toVC.view.alpha = 1
            // tabBarController.view.addSubview(toVC.view)
            
            tabBarController.view.addSubview(toNav.view)
            // toNav.view.addSubview(toVC.view)
            
            // self.toVC.navigationController?.navigationBar.isHidden = false
            snapShotView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
