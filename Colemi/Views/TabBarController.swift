//
//  TabBarViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/22/24.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        let lobbyViewController = LobbyViewController()
        let lobbyNavController = UINavigationController(rootViewController: lobbyViewController)
        lobbyNavController.tabBarItem.title = "Lobby"
        
        let paletteViewController = PaletteViewController()
        paletteViewController.title = "Palette"
        
        let pickPhotoViewController = PickPhotoViewController()
        let pickPhotoNavController = UINavigationController(rootViewController: pickPhotoViewController)
        pickPhotoNavController.tabBarItem.title = "Post"
        
        let chatRoomsViewController = ChatRoomsViewController()
        let chatRoomsNavController = UINavigationController(rootViewController: chatRoomsViewController)
        chatRoomsNavController.tabBarItem.title = "Chat"
        
        let profileViewController = ProfileViewController()
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        profileNavController.tabBarItem.title = "Profile"
        
        setViewControllers([lobbyNavController, paletteViewController, pickPhotoNavController , chatRoomsNavController, profileNavController], animated: false)
    }
}
