//
//  ChatRoomVCPopAnimator.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/11/24.
//

import UIKit

final class ChatRoomVCPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.25
    
    var fromVC: ChatRoomViewController
    
    init(fromVC: ChatRoomViewController) {
        self.fromVC = fromVC
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let toVC = transitionContext.viewController(forKey: .to) as? ImageDetailViewController,
              let imageView = fromVC.tappedImageView,
              let cell = fromVC.tappedCell
        else { return }
        
        imageView.isHidden = true
        
        // let snapShotView = cell.snapshotView(afterScreenUpdates: false)
        
        let snapShotView = imageView.snapshotView(afterScreenUpdates: false)
        
        guard let snapShotView = snapShotView else { return }
        
//        snapShotView.frame = collectionView.convert(cell.frame, to: nil)
        snapShotView.frame = cell.convert(imageView.frame, to: nil)
        toVC.view.alpha = 0
        toVC.imageView.image = imageView.image
        let ratio = (imageView.image?.size.width)! / fromVC.view.frame.width
        toVC.imageViewHeightCons?.constant = (imageView.image?.size.height)! / ratio
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        containerView.addSubview(snapShotView)
        
        toVC.view.layoutIfNeeded()
        
        UIView.animate(withDuration: duration) {
            snapShotView.frame = toVC.imageView.frame
            
        } completion: { _ in
            
            imageView.isHidden = false
            toVC.view.alpha = 1
            // selectedImageView.isHidden = false
            // toVC.toViewImageView.image = UIImage.image
            snapShotView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
