//
//  DismissAnimator.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/26/24.
//

import UIKit

final class AllandMixColorVCDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var childVCIndex: Int
    
    init(childVCIndex: Int) {
        self.childVCIndex = childVCIndex
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
              let tabBarController = transitionContext.viewController(forKey: .to) as? TabBarController,
              let lobbyViewController = tabBarController.lobbyViewController
        else { return }
        
        var toVC: AllAndMixVCProtocol?
        
        switch childVCIndex {
        case 0:
            toVC = lobbyViewController.children[0] as? AllColorViewController
        case 2:
            toVC = lobbyViewController.children[2] as? MixColorViewController
        default:
            break
        }
        
        guard let toVC = toVC,
              let cell = toVC.selectedCell
        else { return }
        
        let fromVCHeader = fromVC.headerView

        fromVC.view.isHidden = true
        
        let snapShotView = cell.snapshotView(afterScreenUpdates: false)
        guard let snapShotView = snapShotView else { return }
        
        var frame = fromVCHeader.photoImageView.frame
        frame.origin.x += fromVC.xPosition
        frame.origin.y += 60 + fromVC.yPosition
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
