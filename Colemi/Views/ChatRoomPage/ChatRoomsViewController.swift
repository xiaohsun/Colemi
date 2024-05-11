//
//  ChatRoomsViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/20/24.
//

import UIKit

class ChatRoomsViewController: UIViewController {
    
    // var userData: UserManager?
    let viewModel = ChatRoomsViewModel()
    
//    lazy var createChatRoomButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Create user 1,2 ChatRoom", for: .normal)
//        button.backgroundColor = ThemeColorProperty.darkColor.getColor()
//        button.addTarget(self, action: #selector(createChatRoomButtonTapped), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
//    @objc private func createChatRoomButtonTapped() {
//        // viewModel.createDetailedChatRoom()
//    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatRoomTableViewCell.self, forCellReuseIdentifier: ChatRoomTableViewCell.reuseIdentifier)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        // tableView.separatorStyle = .singleLine
        tableView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        return tableView
    }()
    
    private func setUpUI() {
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        view.addSubview(tableView)
        // view.addSubview(createChatRoomButton)
        
        navigationItem.title = "訊息"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: FontProperty.GenSenRoundedTW_M.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: ThemeColorProperty.darkColor.getColor()]
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
//            createChatRoomButton.heightAnchor.constraint(equalToConstant: 50),
//            createChatRoomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
//            createChatRoomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            createChatRoomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        viewModel.getSimpleChatRoomDataRealTime {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        userData = UserManager.shared
//        tableView.reloadData()
        tabBarController?.tabBar.isHidden = false
    }
}

extension ChatRoomsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userData.chatRooms.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userData = viewModel.userData
        let cell = tableView.cellForRow(at: indexPath) as? ChatRoomTableViewCell
        let chatRoomViewController = ChatRoomViewController()
        let simpleChatRoom = userData.chatRooms[indexPath.item]
        chatRoomViewController.viewModel.chatRoomID = simpleChatRoom.id
        chatRoomViewController.viewModel.otherUserName = simpleChatRoom.receiverName
        // chatRoomViewController.viewModel.otherUserAvatarUrl = simpleChatRoom.receiverAvatarURL
        chatRoomViewController.viewModel.otherUserAvatarImage = cell?.avatarImageView.image
        
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewCell.reuseIdentifier, for: indexPath) as? ChatRoomTableViewCell else { return UITableViewCell() }
        let userData = viewModel.userData
        
        cell.update(simpleChatRoomData: userData.chatRooms[indexPath.item])
        
        return cell
    }
}
