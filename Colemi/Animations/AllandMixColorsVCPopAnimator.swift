//
//  PopAnimator.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/26/24.
//

import UIKit

final class AllandMixColorsVCPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
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
              let lobbyViewController = tabBarController.lobbyViewController
                
        else { return }
        
        var fromVC: AllAndMixVCProtocol?
        
        switch childVCIndex {
        case 0:
            fromVC = lobbyViewController.children[0] as? AllColorViewController
        case 2:
            fromVC = lobbyViewController.children[2] as? MixColorViewController
        default:
            break
        }
        
        guard let fromVC = fromVC,
              let cell = fromVC.selectedCell,
              let selectedImageView = fromVC.selectedImageView
        else { return }
        
        
        cell.isHidden = true
        
        let snapShotView = cell.snapshotView(afterScreenUpdates: false)
        // snapShotView?.contentMode = .scaleAspectFill
        
        guard let snapShotView = snapShotView else { return }
        // snapShotView.frame = fromVC.selectedImageView!.frame
        
        // snapShotView.frame = UIAccessibility.convertToScreenCoordinates(cell!.frame, in: cell!)
        
        // snapShotView.frame = fromVC.selectedCell!.frame
        // fromVC?.selectedImageView.isHidden = true
        
        // containerView.convert(fromVC.selectedImageView!.frame, from: fromVC.view)
        
        let width = containerView.convert(cell.frame, to: tabBarController.view).width
        let height = containerView.convert(cell.frame, to: tabBarController.view).height
        let xPosition = fromVC.selectedCell!.frame.origin.x
        let yPosition = fromVC.postsCollectionView.convert(cell.frame, to: nil).origin.y // 對的
        
        // let yPosition = cell!.convert(cell!.frame, to: window!).origin.y // 這只有在第一行 cell 成功
        // 寬高x是對的
        
        // snapShotView.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        snapShotView.frame = fromVC.postsCollectionView.convert(cell.frame, to: nil)
        
        // toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0
        
        // containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        containerView.insertSubview(toNav.view, belowSubview: fromVC.view)
        containerView.addSubview(snapShotView)
        
        toVC.view.layoutIfNeeded()
        toVC.tableView.layoutIfNeeded()
        
        UIView.animate(withDuration: duration) {
            snapShotView.frame = toVC.headerView!.photoImageView.frame
            snapShotView.frame.origin.y += toNav.view.safeAreaLayoutGuide.layoutFrame.origin.y
            fromVC.view.alpha = 0
            tabBarController.tabBar.alpha = 0
            
        } completion: { _ in
            
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
