//
//  ProfileViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    
    let viewModel = ProfileViewModel()
    var isOthersPage: Bool = false
    var isShowingPosts: Bool = true
    var isFromDetailPage: Bool = false
    
    var selectedCell: LobbyPostCell?
    var selectedImageView: UIImageView?
    var collectionViewInPostsAndSavesCell: UICollectionView?
    
    var popAnimator: UIViewControllerAnimatedTransitioning?
    var dismissAnimator: UIViewControllerAnimatedTransitioning?
    
    let informationCell = InformationCell()
    let missionCell = MissionCell()
    let postsAndSavesCell = PostsAndSavesCell()
    let selectorHeaderView = SelectorHeaderView()
    
    var subscriptions = Set<AnyCancellable>()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderTopPadding = 0
        
        return tableView
    }()
    
    private func setupUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(popNav))
        navigationItem.leftBarButtonItem?.tintColor = ThemeColorProperty.darkColor.getColor()
        
        if isOthersPage {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(openPopUp))
            navigationItem.rightBarButtonItem?.tintColor = ThemeColorProperty.darkColor.getColor()
        }
    }
    
    @objc private func popNav() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func openPopUp() {
        let overLayPopUp = OverLayPopUp()
        if let otherUserID = viewModel.otherUserData.value?.id,
           let otherUserBeBlocked = viewModel.otherUserData.value?.beBlocked {
            overLayPopUp.viewModel.otherUserID = otherUserID
            overLayPopUp.viewModel.otherUserbeBlocked = otherUserBeBlocked
        }
        overLayPopUp.appear(sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        popAnimator = ProfileVCPopAnimator(fromVC: self, isFromDetailPage: isFromDetailPage)
        dismissAnimator = ProfileVCDismissAnimator(toVC: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isOthersPage {
            Task {
                await viewModel.getUserData {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            viewModel.otherUserData.sink(receiveValue: { _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }).store(in: &subscriptions)
            viewModel.getOtherUserData()
        }
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = ThemeColorProperty.lightColor.getColor()
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userData = viewModel.userData
        
        switch indexPath.section {
        case 0:
            
            if !isOthersPage {
                informationCell.update(name: userData.name, followers: userData.followers, following: userData.following, isOthersPage: isOthersPage, avatarUrl: userData.avatarPhoto)
                
            } else {
                guard let otherUserData = viewModel.otherUserData.value else {
                    print("Error get otherUserData.")
                    return informationCell
                }
                informationCell.viewModel.otherUserData = otherUserData
                informationCell.update(name: otherUserData.name, followers: otherUserData.followers, following: otherUserData.following, isOthersPage: isOthersPage, avatarUrl: otherUserData.avatarPhoto)
            }
            
            informationCell.delegate = self
            informationCell.viewController = self
            
            return informationCell
            
        case 1:
            
            if isOthersPage {
                guard let otherUserData = viewModel.otherUserData.value else {
                    print("Error get otherUserData.")
                    return missionCell
                }
                let colorTodayHex = otherUserData.colorToday
                missionCell.update(color: colorTodayHex)
                
                return missionCell
                
            } else {
                let colorTodayHex = userData.colorToday
                missionCell.update(color: colorTodayHex)
                
                return missionCell
            }
            
            
        default:

            postsAndSavesCell.update(viewModel: viewModel)
            postsAndSavesCell.delegate = self
            
            if !isOthersPage {
                
                Task {
                    await viewModel.getMyPosts(postIDs: userData.posts) {
                        self.postsAndSavesCell.updatePostsCollectionViewLayout()
                    }
                    
                    await viewModel.getMySaves(savesIDs: userData.savedPosts) {
                        self.postsAndSavesCell.updateSavesCollectionViewLayout()
                    }
                }
                
            } else {
                guard let otherUserData = viewModel.otherUserData.value else {
                    print("Error get otherUserData.")
                    return postsAndSavesCell
                }
                
                Task {
                    await viewModel.getMyPosts(postIDs: otherUserData.posts) {
                        self.postsAndSavesCell.updatePostsCollectionViewLayout()
                    }
                    
                    await viewModel.getMySaves(savesIDs: otherUserData.savedPosts) {
                        self.postsAndSavesCell.updateSavesCollectionViewLayout()
                    }
                }
            }
            
            return postsAndSavesCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 325
        } else if indexPath.section == 1 {
            return 120
        } else {
            return UITableView.automaticDimension
            // return 2000
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 2 {
            
            selectorHeaderView.delegate = self
            
            return selectorHeaderView
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
    
    func postsSavesChange(isMyPosts: Bool) {
        if let headerView = tableView.headerView(forSection: 2) as? SelectorHeaderView {
            headerView.postsButton.isSelected = isMyPosts ? true : false
            headerView.savesButton.isSelected = isMyPosts ? false : true
        }
    }
    
    func reloadTableView() {
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.layoutIfNeeded()
            tableView.endUpdates()
        }
    }
    
    func presentDetailPage(index: Int, isMyPosts: Bool, selectedCell: LobbyPostCell, collectionView: UICollectionView, selectedImageView: UIImageView) {
        let postDetailViewController = PostDetailViewController()
        self.selectedCell = selectedCell
        self.collectionViewInPostsAndSavesCell = collectionView
        self.selectedImageView = selectedImageView
        
        if isMyPosts {
            postDetailViewController.viewModel.post = viewModel.posts[index]
            postDetailViewController.viewModel.contentJSONString = viewModel.contentJSONString[index]
            postDetailViewController.viewModel.imageUrl = viewModel.posts[index].imageUrl
            postDetailViewController.viewModel.postID = viewModel.posts[index].id
            postDetailViewController.viewModel.authorID = viewModel.posts[index].authorId
            
        } else {
            postDetailViewController.viewModel.post = viewModel.saves[index]
            postDetailViewController.viewModel.contentJSONString = viewModel.savesContentJSONString[index]
            postDetailViewController.viewModel.imageUrl = viewModel.saves[index].imageUrl
            postDetailViewController.viewModel.postID = viewModel.saves[index].id
            postDetailViewController.viewModel.authorID = viewModel.saves[index].authorId
        }
        
        let navController = UINavigationController(rootViewController: postDetailViewController)
        navController.modalPresentationStyle = .custom
        navController.transitioningDelegate = self
        navController.navigationBar.isHidden = true
        present(navController, animated: true)
    }
}

extension ProfileViewController: SelectorHeaderViewDelegate {
    func changeShowingPostsOrSaved(isShowingMyPosts: Bool) {
        self.isShowingPosts = isShowingMyPosts
        let indexPath = IndexPath(row: 0, section: 2)
        if let cell = tableView.cellForRow(at: indexPath) as? PostsAndSavesCell {
            switch isShowingMyPosts {
            case true:
                cell.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            case false:
                cell.scrollView.setContentOffset(CGPoint(x: cell.scrollView.bounds.width, y: 0), animated: true)
            }
        }
    }
}

extension ProfileViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return popAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimator
    }
}

extension ProfileViewController: InformationCellDelegate {
    func pushToSettingVC() {
        let settingViewController = SettingViewController()
        navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    func pushToChatRoom(chatRoomID: String, avatarImage: UIImage) {
        guard let otherUserData = viewModel.otherUserData.value else { return }
        
        let chatRoomViewController = ChatRoomViewController()
        chatRoomViewController.viewModel.chatRoomID = chatRoomID
        chatRoomViewController.viewModel.otherUserName = otherUserData.name
        chatRoomViewController.viewModel.otherUserAvatarImage = avatarImage
        
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
    
    func pushToFollowVC(isFollowersTapped: Bool) {
        let followViewController = FollowViewController()
        if isOthersPage {
            guard let otherUserData = viewModel.otherUserData.value else { return }
            followViewController.viewModel.userName = otherUserData.name
            followViewController.viewModel.followers = otherUserData.followers
            followViewController.viewModel.followings = otherUserData.following
        } else {
            followViewController.viewModel.userName = viewModel.userData.name
            followViewController.viewModel.followers = viewModel.userData.followers
            followViewController.viewModel.followings = viewModel.userData.following
        }
        
        followViewController.isFollowersTapped = isFollowersTapped
        navigationController?.pushViewController(followViewController, animated: true)
    }
}
