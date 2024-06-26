//
//  TabBarViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/22/24.
//

import UIKit
import FirebaseAuth

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var lobbyViewController: LobbyViewController?
    var profileViewController: ProfileViewController?
    var chatRoomsNavController: UINavigationController?
    let userData = UserManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setButton()
        
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        
        if UserManager.shared.colorSetToday.isEmpty {
            UserManager.shared.colorSetToday = ["#A6EDED", "#FEFFA8", "#FF8A8A"]
            if UserManager.shared.mixColorToday == "" {
                UserManager.shared.colorToday = "#A6EDED"
            } else {
                UserManager.shared.colorToday = UserManager.shared.mixColorToday
            }
        }

        self.delegate = self
    }
    
    private func setupTabs() {
        
        let lobbyViewController = LobbyViewController()
        self.lobbyViewController = lobbyViewController
        let lobbyNavController = UINavigationController(rootViewController: lobbyViewController)
        lobbyNavController.tabBarItem.image = UIImage.lobbyIcon
        lobbyNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        let paletteViewController = PaletteViewController()
        paletteViewController.tabBarItem.image = UIImage.palleteIcon
        paletteViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        let writePostContentViewController = WritePostContentViewController()
        
        let chatRoomsViewController = ChatRoomsViewController()
        let chatRoomsNavController = UINavigationController(rootViewController: chatRoomsViewController)
        self.chatRoomsNavController = chatRoomsNavController
        chatRoomsNavController.tabBarItem.image = UIImage.chatIcon
        chatRoomsNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        let profileViewController = ProfileViewController()
        self.profileViewController = profileViewController
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        profileNavController.tabBarItem.image = UIImage.profileIcon
        profileNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        setViewControllers([lobbyNavController, paletteViewController, writePostContentViewController, chatRoomsNavController, profileNavController], animated: false)
    }
    
    private func setButton() {
        let button = UIButton()
        tabBar.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor, constant: -13),
            button.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        button.setImage(.postIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        view.layoutIfNeeded()
    }
    
    @objc private func buttonTapped() {
        if Auth.auth().currentUser == nil {
            CustomFunc.needLoginAlert(title: "需要登入", message: "登入才能使用此功能唷", vc: self, actionHandler: nil )
            return
        } else {
            if userData.postToday != "" {
                let popUp = DidPostTodayPopUp()
                popUp.appear(sender: self)
            } else {
                let writePostContentViewController = WritePostContentViewController()
                let writePostContentNavController = UINavigationController(rootViewController: writePostContentViewController)
                
                writePostContentNavController.modalPresentationStyle = .fullScreen
                
                present(writePostContentNavController, animated: true)
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)
        guard let selectedIndex = selectedIndex else { return true }
        
        if selectedIndex == 2 {
            return false
        } else if selectedIndex == 0 {
            return true
        } else {
            if Auth.auth().currentUser == nil {
                CustomFunc.needLoginAlert(title: "需要登入", message: "登入才能使用此功能唷", vc: self, actionHandler: nil )
                return false
            } else {
                return true
            }
        }
    }
}
