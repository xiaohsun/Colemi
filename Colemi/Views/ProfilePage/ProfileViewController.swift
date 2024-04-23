//
//  ProfileViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let viewModel = ProfileViewModel()
    var userData: UserManager?
    var isOthersPage: Bool = false
    var othersID: String?
    var otherUserData: User?
    var isShowingMyPosts: Bool = true
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(InformationCell.self, forCellReuseIdentifier: InformationCell.reuseIdentifier)
        tableView.register(MissionCell.self, forCellReuseIdentifier: MissionCell.reuseIdentifier)
        tableView.register(SelectorHeaderView.self, forHeaderFooterViewReuseIdentifier: SelectorHeaderView.reuseIdentifier)
        tableView.register(PostsAndSavesCell.self, forCellReuseIdentifier: PostsAndSavesCell.reuseIdentifier)
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderTopPadding = 0
        
        return tableView
    }()
    
    private func setUpUI() {
        view.addSubview(tableView)
        
        navigationController?.navigationBar.barTintColor = ThemeColorProperty.darkColor.getColor()
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userData = UserManager.shared
        tableView.reloadData()
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userData = userData else { return UITableViewCell()}
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InformationCell.reuseIdentifier, for: indexPath) as? InformationCell else { return UITableViewCell() }
            
            if !isOthersPage {
                cell.update(name: userData.name, followers: userData.followers, following: userData.following, isOthersPage: isOthersPage)
            } else {
                guard let otherUserData = otherUserData else {
                    print("Error get otherUserData.")
                    return cell
                }
                cell.update(name: otherUserData.name, followers: otherUserData.followers, following: otherUserData.following, isOthersPage: isOthersPage)
            }
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MissionCell.reuseIdentifier, for: indexPath) as? MissionCell else { return UITableViewCell() }
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostsAndSavesCell.reuseIdentifier, for: indexPath) as? PostsAndSavesCell else { return UITableViewCell() }
            cell.update(viewModel: viewModel)
            cell.delegate = self
            if !isOthersPage {
                if isShowingMyPosts {
                    Task {
                        await viewModel.getMyPosts(postIDs: userData.posts) {
                            cell.updateLayout()
                        }
                    }
                } else {
                    Task {
                        await viewModel.getMyPosts(postIDs: userData.savedPosts) {
                            cell.updateLayout()
                        }
                    }
                }
                
            } else {
                guard let otherUserData = otherUserData else {
                    print("Error get otherUserData.")
                    return cell
                }
                
                Task {
                    await viewModel.getMyPosts(postIDs: otherUserData.posts) {
                        cell.updateLayout()
                    }
                }
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 325
        } else if indexPath.section == 1 {
            return 120
        } else {
            // return UITableView.automaticDimension
            return 2000
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SelectorHeaderView.reuseIdentifier) as? SelectorHeaderView else { return nil }
            headerView.delegate = self
            
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

extension ProfileViewController: PostsAndSavesCellDelegate {
    func reloadTableView() {
        tableView.layoutIfNeeded()
    }
    
    func presentDetailPage(index: Int) {
        let postDetailViewController = PostDetailViewController()
        postDetailViewController.viewModel.post = viewModel.posts[index]
        postDetailViewController.contentJSONString = viewModel.contentJSONString[index]
        // postDetailViewController.photoImage = viewModel.images[index]
        postDetailViewController.imageUrl = viewModel.posts[index].imageUrl
        // navigationController?.pushViewController(postDetailViewController, animated: true)
        postDetailViewController.postID = viewModel.posts[index].id
        postDetailViewController.authorID = viewModel.posts[index].authorId
        postDetailViewController.comments = viewModel.posts[index].comments
        postDetailViewController.post = viewModel.posts[index]
        
        present(postDetailViewController, animated: true)
    }
}

extension ProfileViewController: SelectorHeaderViewDelegate {
    func changeShowingPostsOrSaved(isShowingMyPosts: Bool) {
        self.isShowingMyPosts = isShowingMyPosts
        print("Hi delegate")
        tableView.reloadData()
    }
}
