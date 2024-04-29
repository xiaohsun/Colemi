//
//  TabBarViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/22/24.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var lobbyViewController: LobbyViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
        setButton()
        // tabBar.barTintColor = UIColor(hex: "#414141")
        // tabBar.tintColor = UIColor(hex: "#F9F4E8")
        self.delegate = self
    }
    
    private func setUpTabs() {
        
        let lobbyViewController = LobbyViewController()
        self.lobbyViewController = lobbyViewController
        let lobbyNavController = UINavigationController(rootViewController: lobbyViewController)
        lobbyNavController.tabBarItem.image = UIImage.lobbyIcon
        lobbyNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        let paletteViewController = PaletteViewController()
        paletteViewController.tabBarItem.image = UIImage.palleteIcon
        paletteViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
//        let pickPhotoViewController = PickPhotoViewController()
//        let pickPhotoNavController = UINavigationController(rootViewController: pickPhotoViewController)
//        pickPhotoNavController.tabBarItem.image = UIImage.postIcon
//        pickPhotoNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        let writePostContentViewController = WritePostContentViewController()
        // let writePostContentNavController = UINavigationController(rootViewController: writePostContentViewController)
        // writePostContentNavController.tabBarItem.image = UIImage.postIcon
        // writePostContentNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        let chatRoomsViewController = ChatRoomsViewController()
        let chatRoomsNavController = UINavigationController(rootViewController: chatRoomsViewController)
        chatRoomsNavController.tabBarItem.image = UIImage.chatIcon
        chatRoomsNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        let profileViewController = ProfileViewController()
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
            button.widthAnchor.constraint(equalToConstant: 70),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        button.setImage(.postIcon, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        
        view.layoutIfNeeded()
    }
    
    @objc private func buttonTapped() {
        let writePostContentViewController = WritePostContentViewController()
        let writePostContentNavController = UINavigationController(rootViewController: writePostContentViewController)
        
        writePostContentNavController.modalPresentationStyle = .fullScreen
        
        present(writePostContentNavController, animated: true)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)
        guard let selectedIndex = selectedIndex else { return true }
        
        if selectedIndex == 2 {
            return false
        } else {
            return true
        }
    }
}
