//
//  FollowingsViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/5/24.
//

import UIKit

class FollowingsViewController: UIViewController, FollowChildVCProtocol {
    
    var viewModel: FollowViewModel?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        tableView.register(FollowTableViewCell.self, forCellReuseIdentifier: FollowTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getFollowingsData()
    }
    
    private func getFollowingsData() {
        guard let followings = viewModel?.followings else { return }
        Task {
            await self.viewModel?.getFollowData(userIDs: followings, getFollowers: false, completion: { [weak self] in
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowTableViewCell.reuseIdentifier, for: indexPath) as? FollowTableViewCell,
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
