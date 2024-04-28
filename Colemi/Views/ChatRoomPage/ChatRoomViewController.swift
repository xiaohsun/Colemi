//
//  ChatRoomViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    let userData = UserManager.shared
    // 傳過來的資料要放哪
    let viewModel = ChatRoomViewModel()
    // var chatRoomID: String = ""
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OtherChatBubbleTableViewCell.self, forCellReuseIdentifier: OtherChatBubbleTableViewCell.reuseIdentifier)
        tableView.register(MyChatBubbleTableViewCell.self, forCellReuseIdentifier: MyChatBubbleTableViewCell.reuseIdentifier)
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        return tableView
    }()
    
    lazy var chatTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = ThemeColorProperty.darkColor.getColor().cgColor
        textView.layer.borderWidth = 1.5
        textView.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        textView.backgroundColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(sendMessageButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont(name: FontProperty.GenSenRoundedTW_R.rawValue, size: 18)
        button.backgroundColor = ThemeColorProperty.darkColor.getColor()
        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        return button
    }()
    
    @objc private func sendMessageButtonTapped() {
        if var messageBody = chatTextView.text {
            
            Task {
                await viewModel.updateUsersSimpleChatRoom(latestMessage: chatTextView.text)
                DispatchQueue.main.async {
                    self.chatTextView.text = ""
                }
            }
            
            // 更新 user chatroom 的時間
            // 更新 Chatroom 內的 messages
        }
    }
    
    private func setUpUI() {
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        view.addSubview(tableView)
        view.addSubview(chatTextView)
        view.addSubview(sendMessageButton)
        
        tabBarController?.tabBar.isHidden = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            chatTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            chatTextView.heightAnchor.constraint(equalToConstant: 40),
            chatTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
            
            sendMessageButton.leadingAnchor.constraint(equalTo: chatTextView.trailingAnchor, constant: 12),
            sendMessageButton.centerYAnchor.constraint(equalTo: chatTextView.centerYAnchor),
            sendMessageButton.heightAnchor.constraint(equalToConstant: 30),
            sendMessageButton.widthAnchor.constraint(equalToConstant: 50),
            sendMessageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        viewModel.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 5
        viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.messages[indexPath.item].senderID == userData.id {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatBubbleTableViewCell.reuseIdentifier, for: indexPath) as? MyChatBubbleTableViewCell else { return UITableViewCell() }
            
            cell.update(messageData: viewModel.messages[indexPath.item])
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherChatBubbleTableViewCell.reuseIdentifier, for: indexPath) as? OtherChatBubbleTableViewCell else { return UITableViewCell() }
            
            cell.update(messageData: viewModel.messages[indexPath.item])
            
            return cell
        }
        
//        if indexPath.item == 1 || indexPath.item == 4 {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherChatBubbleTableViewCell.reuseIdentifier, for: indexPath) as? OtherChatBubbleTableViewCell else { return UITableViewCell() }
//            
//            return cell
//        } else {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatBubbleTableViewCell.reuseIdentifier, for: indexPath) as? MyChatBubbleTableViewCell else { return UITableViewCell() }
//            
//            return cell
//        }
    }
}

extension ChatRoomViewController: ChatRoomViewModelDelegate {
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}