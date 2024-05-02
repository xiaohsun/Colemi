//
//  MixColorVCDismissAnimator.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/2/24.
//

import UIKit

final class TodayColorVCDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        guard let fromVC = transitionContext.viewController(forKey: .from) as? PostDetailViewController,
              let tabBarController = transitionContext.viewController(forKey: .to) as? TabBarController,
              let todayColorVC = tabBarController.lobbyViewController?.children[1]
        else { return }
        
        var toVC: ColorPostsViewController?
        
        switch childVCIndex {
        case 0:
            toVC = todayColorVC.children[0] as? FirstColorViewController
        case 1:
            toVC = todayColorVC.children[1] as? SecondColorViewController
        case 2:
            toVC = todayColorVC.children[2] as? ThirdColorViewController
        default:
            break
        }
        
        guard let toVC = toVC,
              let cell = toVC.selectedCell,
              let fromVCHeader = fromVC.headerView
        else { return }
        
        fromVC.view.isHidden = true
        
        let snapShotView = cell.snapshotView(afterScreenUpdates: false)
        guard let snapShotView = snapShotView else { return }
        
        var frame = fromVCHeader.photoImageView.frame
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
            tabBarController.lobbyViewController?.scrollView.addSubview(todayColorVC.view)
            transitionContext.completeTransition(true)
        }
    }
}
