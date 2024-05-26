//
//  ChooseColorAnimations.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/26/24.
//

import UIKit

// MARK: - Animation
extension ChooseColorViewController {
    // 晴天最初的位置
    internal func setupSunnyInitPosition() {
        view.addSubview(auraImageView)
        
        NSLayoutConstraint.activate([
            auraImageView.widthAnchor.constraint(equalTo: colorView3.widthAnchor, constant: 145),
            auraImageView.heightAnchor.constraint(equalTo: colorView3.heightAnchor, constant: 145),
            auraImageView.centerXAnchor.constraint(equalTo: colorView1.centerXAnchor),
            auraImageView.centerYAnchor.constraint(equalTo: colorView1.centerYAnchor)
        ])
    }
    
    // 下雨天最初的位置
    internal func setupRainInitPosition() {
        raindropView1TopCons = raindropImageView1.topAnchor.constraint(equalTo: colorView1.bottomAnchor, constant: -100)
        raindropView2TopCons = raindropImageView2.topAnchor.constraint(equalTo: colorView2.bottomAnchor, constant: -90)
        raindropView3TopCons = raindropImageView3.topAnchor.constraint(equalTo: colorView3.bottomAnchor, constant: -100)
        
        raindropView1TopCons?.isActive = true
        raindropView2TopCons?.isActive = true
        raindropView3TopCons?.isActive = true
    }
    
    internal func sunnyAnimation() {
        
//        for index in 0..<colorViews.count {
//            colorContainerViews[index].layer.cornerRadius = colorContainerViews[index].frame.width / 2
//        }
        
        for colorView in self.colorViews {
            colorView.alpha = 1
        }
        
        self.colorView1WidthCons?.constant = -70
        self.colorView1YCons?.constant = -230
        
        UIView.animate(withDuration: 1.4, delay: 0.8, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseIn) {
            self.view.layoutIfNeeded()
            
        } completion: { _ in
            self.colorView3WidthCons?.constant = 30
            
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
                
            } completion: { _ in
                self.colorView2WidthCons?.constant = 60
                
                UIView.animate(withDuration: 0.4) {
                    self.view.layoutIfNeeded()
                    
                } completion: { _ in
                    UIView.animate(withDuration: 0.4, delay: 0.6) {
                        self.auraImageView.alpha = 1
                        
                    } completion: { _ in
                        UIView.animate(withDuration: 0.6, delay: 0.4) {
                            self.auraImageView.transform = self.auraImageView.transform.rotated(by: .pi * 1.5)
                            
                        } completion: { _ in
                            UIView.animate(withDuration: 0.6) {
                                self.auraImageView.transform = self.auraImageView.transform.rotated(by: .pi * 1.5)
                                
                            } completion: { _ in
                                UIView.animate(withDuration: 0.4, delay: 0.6) {
                                    self.auraImageView.alpha = 0
                                    
                                } completion: { _ in
                                        self.colorView1XCons?.isActive = false
                                        self.colorView1YCons?.isActive = false
                                        self.colorView2XCons?.isActive = false
                                        self.colorView2YCons?.isActive = false
                                        self.colorView3XCons?.isActive = false
                                        self.colorView3YCons?.isActive = false
                                        
                                        self.colorView1XCons = self.colorView1.centerXAnchor.constraint(equalTo: self.colorContainerView1.centerXAnchor)
                                        self.colorView1YCons = self.colorView1.centerYAnchor.constraint(equalTo: self.colorContainerView1.centerYAnchor)
                                        
                                        self.colorView1WidthCons?.constant = 0
                                        
                                        self.colorView2XCons = self.colorView2.centerXAnchor.constraint(equalTo: self.colorContainerView2.centerXAnchor)
                                        self.colorView2YCons = self.colorView2.centerYAnchor.constraint(equalTo: self.colorContainerView2.centerYAnchor)
                                        
                                        self.colorView2WidthCons?.constant = 0
                                        
                                        self.colorView3XCons = self.colorView3.centerXAnchor.constraint(equalTo: self.colorContainerView3.centerXAnchor)
                                        self.colorView3YCons = self.colorView3.centerYAnchor.constraint(equalTo: self.colorContainerView3.centerYAnchor)
                                        
                                        self.colorView3WidthCons?.constant = 0
                                        
                                        self.colorView1XCons?.isActive = true
                                        self.colorView1YCons?.isActive = true
                                        self.colorView2XCons?.isActive = true
                                        self.colorView2YCons?.isActive = true
                                        self.colorView3XCons?.isActive = true
                                        self.colorView3YCons?.isActive = true
                                        
                                        UIView.animate(withDuration: 0.6, delay: 0.45) {
                                            self.view.layoutIfNeeded()
                                            
                                        } completion: { _ in
                                            UIView.animate(withDuration: 0.6) {
                                                for colorContainerView in self.colorContainerViews {
                                                    colorContainerView.alpha = 0.3
                                                }
                                                
                                            } completion: { _ in
                                                UIView.animate(withDuration: 0.6) {
                                                    self.chooseColorLabel.alpha = 1
                                                    self.checkIconImageView.alpha = 1
                                                    self.weatherInfoButton.alpha = 1
                                                }
                                                self.checkIconImageView.isUserInteractionEnabled = true
                                                
                                                for colorView in self.colorViews {
                                                    colorView.isUserInteractionEnabled = true
                                                }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    internal func rainAnimation() {
        
//        for index in 0..<colorViews.count {
//            colorContainerViews[index].layer.cornerRadius = colorContainerViews[index].frame.width / 2
//        }
        
        for colorView in self.colorViews {
            colorView.alpha = 1
        }
        
        self.colorView1XCons?.constant = -10
        self.colorView1YCons?.constant = -250
        self.colorView2XCons?.constant = -30
        self.colorView2YCons?.constant = 60
        self.colorView2WidthCons?.constant = 40
        self.colorView3XCons?.constant = 60
        self.colorView3YCons?.constant = 50
        
        UIView.animate(withDuration: 1.4, delay: 0.8, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseIn) {
            
            self.view.layoutIfNeeded()
        } completion: { _ in
            
            self.raindropImageView1.alpha = 1
            self.raindropImageView2.alpha = 1
            self.raindropImageView3.alpha = 1
            
            self.raindropView1TopCons?.constant = 20
            self.raindropView2TopCons?.constant = 30
            self.raindropView3TopCons?.constant = 20
            
            UIView.animate(withDuration: 0.8, delay: 0.4) {
                
                self.view.layoutIfNeeded()
                
            } completion: { _ in
                
                self.raindropView1TopCons?.constant = -80
                self.raindropView2TopCons?.constant = -80
                self.raindropView3TopCons?.constant = -80
                
                UIView.animate(withDuration: 0.6, delay: 0.6) {
                    
                    self.view.layoutIfNeeded()
                    
                } completion: { _ in
                    
                    self.raindropImageView1.alpha = 0
                    self.raindropImageView2.alpha = 0
                    self.raindropImageView3.alpha = 0
                    
                    self.colorView1XCons?.isActive = false
                    self.colorView1YCons?.isActive = false
                    self.colorView2XCons?.isActive = false
                    self.colorView2YCons?.isActive = false
                    self.colorView3XCons?.isActive = false
                    self.colorView3YCons?.isActive = false
                    self.colorView2WidthCons?.isActive = false
                    self.colorView2HeightCons?.isActive = false
                    
                    self.colorView1XCons = self.colorView1.centerXAnchor.constraint(equalTo: self.colorContainerView1.centerXAnchor)
                    self.colorView1YCons = self.colorView1.centerYAnchor.constraint(equalTo: self.colorContainerView1.centerYAnchor)
                    self.colorView2XCons = self.colorView2.centerXAnchor.constraint(equalTo: self.colorContainerView2.centerXAnchor)
                    self.colorView2YCons = self.colorView2.centerYAnchor.constraint(equalTo: self.colorContainerView2.centerYAnchor)
                    self.colorView3XCons = self.colorView3.centerXAnchor.constraint(equalTo: self.colorContainerView3.centerXAnchor)
                    self.colorView3YCons = self.colorView3.centerYAnchor.constraint(equalTo: self.colorContainerView3.centerYAnchor)
                    self.colorView2WidthCons = self.colorView2.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3)
                    self.colorView2HeightCons =  self.colorView2.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3)
                    
                    self.colorView1XCons?.isActive = true
                    self.colorView1YCons?.isActive = true
                    self.colorView2XCons?.isActive = true
                    self.colorView2YCons?.isActive = true
                    self.colorView3XCons?.isActive = true
                    self.colorView3YCons?.isActive = true
                    self.colorView2WidthCons?.isActive = true
                    self.colorView2HeightCons?.isActive = true
                    
                    UIView.animate(withDuration: 0.6, delay: 0.3) {
                        self.view.layoutIfNeeded()
                    } completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            for colorContainerView in self.colorContainerViews {
                                colorContainerView.alpha = 0.3
                            }
                        } completion: { _ in
                            UIView.animate(withDuration: 0.6) {
                                self.chooseColorLabel.alpha = 1
                                self.checkIconImageView.alpha = 1
                                self.weatherInfoButton.alpha = 1
                            }
                            self.checkIconImageView.isUserInteractionEnabled = true
                            // self.view.isUserInteractionEnabled = true
                            for colorView in self.colorViews {
                                colorView.isUserInteractionEnabled = true
                            }
                        }
                    }
                }
            }
        }
    }
}
