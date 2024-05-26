//
//  FollowersViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/5/24.
//

import UIKit

class FollowersViewController: UIViewController, FollowChildVCProtocol {
    
    var viewModel: FollowViewModel?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FollowTableViewCell.self, forCellReuseIdentifier: FollowTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getFollowersData()
    }
    
    private func getFollowersData() {
        guard let followers = viewModel?.followers else { return }
        Task {
            await self.viewModel?.getFollowData(userIDs: followers, getFollowers: true, completion: { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
}

extension FollowersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let followers = viewModel?.followers else { return 0 }
        return followers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowTableViewCell.reuseIdentifier, for: indexPath) as? FollowTableViewCell,
              let followersAvatarUrls = viewModel?.followersAvatarUrls,
              let followersNames = viewModel?.followersNames
        else { return UITableViewCell() }
        
        let row = indexPath.row
        if followersNames.count != viewModel?.followers.count {
            return cell
        } else {
            cell.update(avatarUrl: followersAvatarUrls[row], userName: followersNames[row])
        }
        
        return cell
    }
}
