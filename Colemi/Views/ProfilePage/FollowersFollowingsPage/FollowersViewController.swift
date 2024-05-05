//
//  FollowersViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/5/24.
//

import UIKit

class FollowersViewController: UIViewController {
    
    var viewModel: FollowersFollowingsViewModel?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FollowersFollowingsTableViewCell.self, forCellReuseIdentifier: FollowersFollowingsTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private func setUpUI() {
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getFollowersData()
    }
    
    private func getFollowersData() {
        guard let followers = viewModel?.followers else { return }
        Task {
            await self.viewModel?.getFollowersData(userIDs: followers, getFollowers: true, completion: { [weak self] in
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowersFollowingsTableViewCell.reuseIdentifier, for: indexPath) as? FollowersFollowingsTableViewCell,
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
