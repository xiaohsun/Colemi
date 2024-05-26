//
//  CustomFunc.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/20/24.
//

import UIKit

class CustomFunc {
    class func customAlert(title: String, message: String, vc: UIViewController, actionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "關閉", style: .default) { _ in
            actionHandler?()
        }
        alertController.addAction(closeAction)
        vc.present(alertController, animated: true)
    }
    
    class func needLoginAlert(title: String, message: String, vc: UIViewController, actionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "關閉", style: .default) { _ in
            actionHandler?()
        }
        let signInAction = UIAlertAction(title: "登入", style: .default) { _ in
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                return
            }
            let loggedInViewController = SignInViewController()
            sceneDelegate.window?.rootViewController = loggedInViewController
        }
        alertController.addAction(closeAction)
        alertController.addAction(signInAction)
        vc.present(alertController, animated: true)
    }
    
    class func getSystemTime() -> String {
        let currectDate = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale.ReferenceType.system
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        return dateFormatter.string(from: currectDate)
    }
}
