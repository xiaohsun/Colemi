//
//  ChatRoomsViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/20/24.
//

import UIKit

class ChatRoomsViewController: UIViewController {
    
    let userManager = UserManager.shared
    let viewModel = ChatRoomsViewModel()
    
    lazy var createChatRoomButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create user 1,2 ChatRoom", for: .normal)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(createChatRoomButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func createChatRoomButtonTapped() {
        print("Hi")
        viewModel.createDetailedChatRoom()
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
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(createChatRoomButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            createChatRoomButton.heightAnchor.constraint(equalToConstant: 50),
            createChatRoomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createChatRoomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            createChatRoomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

extension ChatRoomsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userManager.chatRooms.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatRoomViewController = ChatRoomViewController()
        chatRoomViewController.viewModel.chatRoomID = userManager.chatRooms[indexPath.item].id
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewCell.reuseIdentifier, for: indexPath) as? ChatRoomTableViewCell else { return UITableViewCell() }
        
        cell.update(simpleChatRoomData: userManager.chatRooms[indexPath.item])
        
        return cell
    }
}
