//
//  FollowingsViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/5/24.
//

import UIKit

class FollowingsViewController: UIViewController {
    
    var viewModel: FollowersFollowingsViewModel?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = ThemeColorProperty.lightColor.getColor()
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
        getFollowingsData()
    }
    
    private func getFollowingsData() {
        guard let followings = viewModel?.followings else { return }
        Task {
            await self.viewModel?.getFollowersData(userIDs: followings, getFollowers: false, completion: { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
}

extension FollowingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let followings = viewModel?.followings else { return 0 }
        return followings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowersFollowingsTableViewCell.reuseIdentifier, for: indexPath) as? FollowersFollowingsTableViewCell,
              let followingsAvatarUrls = viewModel?.followingsAvatarUrls,
              let followingsNames = viewModel?.followingsNames
        else { return UITableViewCell() }
        
        let row = indexPath.row
        if followingsNames.count != viewModel?.followings.count {
            return cell
        } else {
            cell.update(avatarUrl: followingsAvatarUrls[row], userName: followingsNames[row])
        }
        
        return cell
    }
}
