//
//  ChatRoomsViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/20/24.
//

import UIKit

class ChatRoomsViewController: UIViewController {
    
    var userData: UserManager?
    let viewModel = ChatRoomsViewModel()
    
    lazy var createChatRoomButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create user 1,2 ChatRoom", for: .normal)
        button.backgroundColor = ThemeColorProperty.darkColor.getColor()
        button.addTarget(self, action: #selector(createChatRoomButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func createChatRoomButtonTapped() {
        // viewModel.createDetailedChatRoom()
    }
    
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
        view.addSubview(createChatRoomButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            createChatRoomButton.heightAnchor.constraint(equalToConstant: 50),
            createChatRoomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            createChatRoomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            createChatRoomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
        tabBarController?.tabBar.isHidden = false
    }
}

extension ChatRoomsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let userData = userData else { return 0 }
        return userData.chatRooms.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userData = userData else { return }
        let chatRoomViewController = ChatRoomViewController()
        chatRoomViewController.viewModel.chatRoomID = userData.chatRooms[indexPath.item].id
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userData = userData, let cell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewCell.reuseIdentifier, for: indexPath) as? ChatRoomTableViewCell else { return UITableViewCell() }
        
        cell.update(simpleChatRoomData: userData.chatRooms[indexPath.item])
        
        return cell
    }
}
