//
//  ChatRoomVCPopAnimator.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/11/24.
//

import UIKit

final class ChatRoomVCPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var fromNav: UINavigationController
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        view.alpha = 0
        return view
    }()
    
    init(fromNav: UINavigationController) {
        self.fromNav = fromNav
        super.init()
    }
    
    private let duration: TimeInterval = 0.25
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard // let tabBarController = transitionContext.viewController(forKey: .from) as? TabBarController,
            // let fromNav = tabBarController.chatRoomsNavController,
              let fromVC = fromNav.topViewController as? ChatRoomViewController,
              let toVC = transitionContext.viewController(forKey: .to) as? ImageDetailViewController,
              let imageView = fromVC.tappedImageView,
              let cell = fromVC.tappedCell
        else { return }
        
        imageView.isHidden = true
        
        let snapShotView = imageView.snapshotView(afterScreenUpdates: false)
        
        guard let snapShotView = snapShotView else { return }
        
        snapShotView.frame = cell.convert(imageView.frame, to: nil)
        toVC.view.alpha = 0
        toVC.imageView.image = imageView.image
        
        let ratio = (imageView.image?.size.width)! / fromVC.view.frame.width
        toVC.imageViewHeightCons?.constant = (imageView.image?.size.height)! / ratio
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(backgroundView)
        containerView.addSubview(snapShotView)
        
        backgroundView.frame = containerView.frame
        
        toVC.view.layoutIfNeeded()
        
        UIView.animate(withDuration: duration) {
            snapShotView.frame = toVC.imageView.frame
            self.backgroundView.alpha = 1
            
        } completion: { _ in
            
            imageView.isHidden = false
            toVC.view.alpha = 1
            snapShotView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
