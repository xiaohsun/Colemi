//
//  ProfileViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        tableView.register(InformationCell.self, forCellReuseIdentifier: InformationCell.reuseIdentifier)
        tableView.register(MissionCell.self, forCellReuseIdentifier: MissionCell.reuseIdentifier)
        tableView.register(SelectorHeaderView.self, forHeaderFooterViewReuseIdentifier: SelectorHeaderView.reuseIdentifier)
        tableView.register(PostsAndSavesCell.self, forCellReuseIdentifier: PostsAndSavesCell.reuseIdentifier)
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InformationCell.reuseIdentifier, for: indexPath) as? InformationCell else { return UITableViewCell() }
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MissionCell.reuseIdentifier, for: indexPath) as? MissionCell else { return UITableViewCell() }
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostsAndSavesCell.reuseIdentifier, for: indexPath) as? PostsAndSavesCell else { return UITableViewCell() }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 325
        } else if indexPath.section == 1 {
            return 120
        } else {
            return 2000
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SelectorHeaderView.reuseIdentifier) as? SelectorHeaderView else { return nil }
            
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            60
        } else {
            0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
