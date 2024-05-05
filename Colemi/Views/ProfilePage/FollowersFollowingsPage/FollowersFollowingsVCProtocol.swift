//
//  FollowersFollowingsVCProtocol.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/5/24.
//

import UIKit

protocol FollowersFollowingsVCProtocol: UIViewController {
    // var viewModel: LobbyViewModel { get }
    var loadedBefore: Bool { get set }
    var tableView: UITableView { get }
    
    func setUpUI()
}

extension FollowersFollowingsVCProtocol {
    func setUpUI() {
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
