//
//  ChatRoomViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    let userData = UserManager.shared
    let viewModel = ChatRoomViewModel()
    let textViewInitHeight: CGFloat = 33
    var chatTextViewHeightCons: NSLayoutConstraint?
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
        textView.delegate = self
        
        return textView
    }()
    
    func chatTextViewInit() {
        chatTextView.font = UIFont(name: FontProperty.GenSenRoundedTW_R.rawValue, size: 16)
        chatTextView.textColor = ThemeColorProperty.darkColor.getColor()
        chatTextView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColorProperty.darkColor.getColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(sendMessageButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.sendIcon, for: .normal)
        return button
    }()
    
    @objc private func sendMessageButtonTapped() {
        
        if chatTextView.text != "" {
            Task {
                await viewModel.updateUsersSimpleChatRoom(latestMessage: chatTextView.text)
                DispatchQueue.main.async {
                    self.chatTextView.text = ""
                }
            }
        }
            // 更新 user chatroom 的時間
            // 更新 Chatroom 內的 messages
    }
    
    lazy var backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        button.addTarget(self, action: #selector(popNav), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.backIcon, for: .normal)
        return button
    }()
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = ThemeColorProperty.lightColor.getColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(popNav))
        navigationItem.leftBarButtonItem?.tintColor = ThemeColorProperty.darkColor.getColor()
        navigationItem.title = viewModel.otherUserName
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: FontProperty.GenSenRoundedTW_M.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: ThemeColorProperty.darkColor.getColor()]
    }
    
    @objc private func popNav() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpUI() {
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        view.addSubview(tableView)
        view.addSubview(containerView)
        containerView.addSubview(chatTextView)
        containerView.addSubview(sendMessageButton)
        
        tabBarController?.tabBar.isHidden = true
        setUpNavigationBar()
        chatTextViewInit()
        
        chatTextViewHeightCons = chatTextView.heightAnchor.constraint(equalToConstant: textViewInitHeight)
        chatTextViewHeightCons?.isActive = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: chatTextView.topAnchor, constant: -25),
            
            chatTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            chatTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -25),
            chatTextView.trailingAnchor.constraint(equalTo: sendMessageButton.leadingAnchor, constant: -20),
            
            sendMessageButton.centerYAnchor.constraint(equalTo: chatTextView.centerYAnchor),
            sendMessageButton.heightAnchor.constraint(equalToConstant: 20),
            sendMessageButton.widthAnchor.constraint(equalToConstant: 20),
            sendMessageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        viewModel.delegate = self
        viewModel.getDetailedChatRoomDataRealTime(chatRoomID: viewModel.chatRoomID)
        
        
    }
}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.messages[indexPath.item].senderID == userData.id {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatBubbleTableViewCell.reuseIdentifier, for: indexPath) as? MyChatBubbleTableViewCell else { return UITableViewCell() }
            
            cell.update(messageData: viewModel.messages[indexPath.item])
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherChatBubbleTableViewCell.reuseIdentifier, for: indexPath) as? OtherChatBubbleTableViewCell
            else { return UITableViewCell() }
            
            cell.update(messageData: viewModel.messages[indexPath.item], avatarImage: viewModel.otherUserAvatarImage ?? UIImage())
            
            return cell
        }
    }
}

extension ChatRoomViewController: ChatRoomViewModelDelegate {
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ChatRoomViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: chatTextView.frame.size.width - 10, height: .infinity)
        let estimatedSize = chatTextView.sizeThatFits(size)
        
        chatTextViewInit()
        
        guard chatTextView.contentSize.height < 100 else {
            chatTextView.isScrollEnabled = true
            return
        }
        
        guard let chatTextViewHeightCons = chatTextViewHeightCons else { return }
        
        chatTextView.isScrollEnabled = false
        
        if estimatedSize.height > textViewInitHeight {
            chatTextViewHeightCons.constant = estimatedSize.height
            chatTextView.addLineSpacing()
        } else {
            chatTextViewHeightCons.constant = textViewInitHeight
        }
    }
}
