//
//  PaletteAnimations.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/26/24.
//

import UIKit

extension PaletteViewController {
    internal func meetColorAnimation() {
        
        myColorViewXCons?.constant = -70
        myColorViewYCons?.constant = 70
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
            self.stopLoopAnimation()
            self.nearbyColorView.layer.cornerRadius = self.nearbyColorView.frame.width / 2
            
        } completion: { _ in
            self.nearbyColorViewWidthCons?.constant = 60
            self.nearbyColorViewHeightCons?.constant = 60
            
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8) {
                self.view.layoutIfNeeded()
                
            } completion: { _ in
                UIView.animate(withDuration: 0.4) {
                    self.mixColorButton.alpha = 1
                }
            }
        }
    }
    
    internal func mixColorAnimation() {
        UIView.animate(withDuration: 0.4) {
            self.saveMixColorButton.alpha = 0
            self.mixColorButton.alpha = 0
            self.findColorLabel.alpha = 0
            
        } completion: { _ in
            self.myColorViewWidthCons?.constant = 100
            self.myColorViewHeightCons?.constant = 100
            
            UIView.animate(withDuration: 0.4, delay: 0.6, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                self.view.layoutIfNeeded()
                
            } completion: { _ in
                self.nearbyColorViewWidthCons?.constant = 100
                self.nearbyColorViewHeightCons?.constant = 100
                
                UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                    self.view.layoutIfNeeded()
                    
                } completion: { _ in
                    self.myColorViewWidthCons?.constant = 140
                    self.myColorViewHeightCons?.constant = 140
                    
                    UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                        self.view.layoutIfNeeded()
                        
                    } completion: { _ in
                        self.nearbyColorViewWidthCons?.constant = 140
                        self.nearbyColorViewHeightCons?.constant = 140
                        
                        UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                            self.view.layoutIfNeeded()
                            
                        } completion: { _ in
                            self.nearbyColorViewWidthCons?.constant = 0
                            self.nearbyColorViewHeightCons?.constant = 0
                            self.myColorViewWidthCons?.constant = 0
                            self.myColorViewHeightCons?.constant = 0
                            
                            UIView.animate(withDuration: 0.4, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                                self.view.layoutIfNeeded()
                                
                            } completion: { _ in
                                self.mixColorViewWidthCons?.constant = 1000
                                self.mixColorViewHeightCons?.constant = 1000
                                
                                UIView.animate(withDuration: 0.4, delay: 0.5) {
                                    self.view.layoutIfNeeded()
                                    self.mixColorView.layer.cornerRadius = self.mixColorView.frame.width / 2
                                    
                                } completion: { _ in
                                    self.findColorLabel.textColor = ThemeColorProperty.darkColor.getColor()
                                    self.findColorLabel.text = "完成混色！"
                                    
                                    UIView.animate(withDuration: 0.4, delay: 0.5) {
                                        self.findColorLabel.alpha = 1
                                        self.saveMixColorButton.alpha = 1
                                        self.tabBarController?.tabBar.alpha = 1
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        
    }
    
    internal func stopLoopAnimation() {
        midColorContainerView.alpha = 0
        bigColorContainerView.alpha = 0
        animationShouldStop = true
    }
    
    internal func containerViewAppearAnimate() {
        UIView.animate(withDuration: 0.6, delay: 0.5) {
            self.midColorContainerView.alpha = 0.3
        } completion: { _ in
            UIView.animate(withDuration: 0.6) {
                self.bigColorContainerView.alpha = 0.3
            } completion: { _ in
                self.containerViewDisappearAnimate()
            }
        }
    }
    
    internal func containerViewDisappearAnimate() {
        UIView.animate(withDuration: 0.6) {
            self.midColorContainerView.alpha = 0
            self.bigColorContainerView.alpha = 0
        } completion: { _ in
            if !self.animationShouldStop {
                self.containerViewAppearAnimate()
            }
        }
    }
}
