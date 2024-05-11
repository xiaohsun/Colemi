//
//  TodayColorViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/2/24.
//

import UIKit

final class TodayColorVCPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        guard let toNav = transitionContext.viewController(forKey: .to) as? UINavigationController,
              let toVC = toNav.topViewController as? PostDetailViewController,
              let tabBarController = transitionContext.viewController(forKey: .from) as? TabBarController,
              let todayColorVC = tabBarController.lobbyViewController?.children[1]
        else { return }
        
        var fromVC: TodayColorVCProtocol?
        
        switch childVCIndex {
        case 0:
            fromVC = todayColorVC.children[0] as? FirstColorViewController
        case 1:
            fromVC = todayColorVC.children[1] as? SecondColorViewController
        case 2:
            fromVC = todayColorVC.children[2] as? ThirdColorViewController
        default:
            break
        }
        
        guard let fromVC = fromVC,
              let cell = fromVC.selectedCell else { return }
        
        cell.isHidden = true
        
        let snapShotView = cell.snapshotView(afterScreenUpdates: false)
        
        guard let snapShotView = snapShotView else { return }
        
        snapShotView.frame = fromVC.postsCollectionView.convert(cell.frame, to: nil)
        
        toVC.view.alpha = 0
        
        containerView.insertSubview(toNav.view, belowSubview: fromVC.view)
        containerView.addSubview(snapShotView)
        
        toVC.view.layoutIfNeeded()
        toVC.tableView.layoutIfNeeded()
        
        UIView.animate(withDuration: duration) {
            // guard let headerView = toVC.headerView else { return }
            let headerView = toVC.headerView
            snapShotView.frame = headerView.photoImageView.frame
            snapShotView.frame.origin.y += 60
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
