//
//  LaunchViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/7/24.
//

import UIKit
import Firebase

class LaunchViewController: UIViewController {
    
    let signInViewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        
        if Auth.auth().currentUser == nil {
//            let preLoginInViewController = PreLoginInViewController()
//            sceneDelegate.window?.rootViewController = preLoginInViewController
            let preLoginInViewController = TutorViewController()
            sceneDelegate.window?.rootViewController = preLoginInViewController
        } else {
            signInViewModel.loginUser()
        }
        
    }
}
