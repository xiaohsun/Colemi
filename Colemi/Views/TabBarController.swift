//
//  TabBarViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/22/24.
//

import UIKit

class TabBarController: UITabBarController {
    
    var lobbyViewController: LobbyViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
        // tabBar.barTintColor = UIColor(hex: "#414141")
        // tabBar.tintColor = UIColor(hex: "#F9F4E8")
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
        
        let pickPhotoViewController = PickPhotoViewController()
        let pickPhotoNavController = UINavigationController(rootViewController: pickPhotoViewController)
        pickPhotoNavController.tabBarItem.image = UIImage.postIcon
        pickPhotoNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        let chatRoomsViewController = ChatRoomsViewController()
        let chatRoomsNavController = UINavigationController(rootViewController: chatRoomsViewController)
        chatRoomsNavController.tabBarItem.image = UIImage.chatIcon
        chatRoomsNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        let profileViewController = ProfileViewController()
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        profileNavController.tabBarItem.image = UIImage.profileIcon
        profileNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        setViewControllers([lobbyNavController, paletteViewController, pickPhotoNavController , chatRoomsNavController, profileNavController], animated: false)
    }
}
