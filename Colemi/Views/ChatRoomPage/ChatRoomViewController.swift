//
//  ChatRoomViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit
import PhotosUI

class ChatRoomViewController: UIViewController {
    
    let userData = UserManager.shared
    let viewModel = ChatRoomViewModel()
    let textViewInitHeight: CGFloat = 33
    // var containerViewTopCons: NSLayoutConstraint?
    var chatTextViewHeightCons: NSLayoutConstraint?
    var imageViewTopCons: NSLayoutConstraint?
    var imageViewWidthCons: NSLayoutConstraint?
    // var chatRoomID: String = ""
    var isSendingImage = false
    var tappedImageView: UIImageView?
    var tappedCell: UITableViewCell?
    
    var popAnimator: ChatRoomVCPopAnimator?
    var dismissAnimator: ChatRoomVCDismissAnimator?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(OtherChatTextBubbleTableViewCell.self, forCellReuseIdentifier: OtherChatTextBubbleTableViewCell.reuseIdentifier)
        tableView.register(MyChatTextBubbleTableViewCell.self, forCellReuseIdentifier: MyChatTextBubbleTableViewCell.reuseIdentifier)
        tableView.register(MyChatImageBubbleTableViewCell.self, forCellReuseIdentifier: MyChatImageBubbleTableViewCell.reuseIdentifier)
        tableView.register(OtherChatImageBubbleTableViewCell.self, forCellReuseIdentifier: OtherChatImageBubbleTableViewCell.reuseIdentifier)
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        tableView.showsVerticalScrollIndicator = false
        
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
    
    private func chatTextViewInit() {
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
    
    lazy var choosePhotoButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(choosePicButtonTapped), for: .touchUpInside)
        button.setImage(.photoSquareIcon, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    @objc private func sendMessageButtonTapped() {
        
        if !isSendingImage {
            if chatTextView.text != "" {
                Task {
                    await viewModel.updateUsersSimpleChatRoom(latestMessage: chatTextView.text, type: 0)
                    DispatchQueue.main.async {
                        self.chatTextView.text = ""
                        self.view.endEditing(true)
                    }
                }
            }
        } else {
            
            guard let imageData = viewModel.imageData, let imageSize = viewModel.imageSize else { return }
            
            viewModel.uploadImgToFirebase(imageData: imageData, imageSize: imageSize)
            
            DispatchQueue.main.async {
                self.isSendingImage = false
                self.imageViewTopCons?.constant = 0
                self.view.endEditing(true)
                
                UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                    self.chatTextView.alpha = 1
                    self.choosePhotoButton.alpha = 1
                    self.sendPicLabel.alpha = 0
                    self.view.layoutIfNeeded()
                } completion: { _ in
                    self.imageViewWidthCons?.constant = 200
                    self.view.layoutIfNeeded()
                    
                }
            }
        }
        // 更新 user chatroom 的時間
        // 更新 Chatroom 內的 messages
    }
    
    @objc private func choosePicButtonTapped() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    lazy var sendPicLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "傳送圖片"
        label.font = UIFont(name: FontProperty.GenSenRoundedTW_M.rawValue, size: 18)
        label.textColor = .white
        label.alpha = 0
        
        return label
    }()
    
//    lazy var backButton: UIButton = {
//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
//        button.addTarget(self, action: #selector(popNav), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(.backIcon, for: .normal)
//        return button
//    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        
        return imageView
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
        view.addSubview(imageView)
        containerView.addSubview(chatTextView)
        containerView.addSubview(sendMessageButton)
        containerView.addSubview(choosePhotoButton)
        containerView.addSubview(sendPicLabel)
        
        tabBarController?.tabBar.isHidden = true
        setUpNavigationBar()
        chatTextViewInit()
        
        chatTextViewHeightCons = chatTextView.heightAnchor.constraint(equalToConstant: textViewInitHeight)
        chatTextViewHeightCons?.isActive = true
        
        imageViewTopCons = imageView.topAnchor.constraint(equalTo: view.bottomAnchor)
        imageViewTopCons?.isActive = true
        
        imageViewWidthCons = imageView.widthAnchor.constraint(equalToConstant: 200)
        imageViewWidthCons?.isActive = true
        
        //        containerViewTopCons = containerView.topAnchor.constraint(equalTo: chatTextView.topAnchor, constant: -25)
        //        containerViewTopCons?.isActive = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.topAnchor),
            
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: chatTextView.topAnchor, constant: -25),
            
            chatTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            chatTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -35),
            chatTextView.trailingAnchor.constraint(equalTo: choosePhotoButton.leadingAnchor, constant: -20),
            
            sendMessageButton.centerYAnchor.constraint(equalTo: chatTextView.centerYAnchor),
            sendMessageButton.heightAnchor.constraint(equalToConstant: 20),
            sendMessageButton.widthAnchor.constraint(equalTo: sendMessageButton.heightAnchor),
            sendMessageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            choosePhotoButton.trailingAnchor.constraint(equalTo: sendMessageButton.leadingAnchor, constant: -20),
            choosePhotoButton.heightAnchor.constraint(equalToConstant: 20),
            choosePhotoButton.widthAnchor.constraint(equalTo: choosePhotoButton.heightAnchor),
            choosePhotoButton.centerYAnchor.constraint(equalTo: sendMessageButton.centerYAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            sendPicLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendPicLabel.centerYAnchor.constraint(equalTo: sendMessageButton.centerYAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        viewModel.delegate = self
        // navigationController?.delegate = self
        viewModel.getDetailedChatRoomDataRealTime(chatRoomID: viewModel.chatRoomID)
    }
}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.messages[indexPath.item].senderID == userData.id {
            
            if viewModel.messages[indexPath.item].type == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatTextBubbleTableViewCell.reuseIdentifier, for: indexPath) as? MyChatTextBubbleTableViewCell else { return UITableViewCell() }
                
                cell.update(messageData: viewModel.messages[indexPath.item])
                //                cell.layoutSubviews()
                //                cell.layoutIfNeeded()
                
                return cell
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatImageBubbleTableViewCell.reuseIdentifier, for: indexPath) as? MyChatImageBubbleTableViewCell else { return UITableViewCell() }
                
                cell.update(messageData: viewModel.messages[indexPath.item])
                //                cell.layoutSubviews()
//                cell.delegate = self
                //                cell.layoutIfNeeded()
                
                return cell
            }
            
            
        } else {
            
            if viewModel.messages[indexPath.item].type == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherChatTextBubbleTableViewCell.reuseIdentifier, for: indexPath) as? OtherChatTextBubbleTableViewCell
                else { return UITableViewCell() }
                
                cell.update(messageData: viewModel.messages[indexPath.item], avatarImage: viewModel.otherUserAvatarImage ?? UIImage())
                //                cell.layoutSubviews()
                //                cell.layoutIfNeeded()
                
                return cell
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherChatImageBubbleTableViewCell.reuseIdentifier, for: indexPath) as? OtherChatImageBubbleTableViewCell
                else { return UITableViewCell() }
                
                cell.update(messageData: viewModel.messages[indexPath.item], avatarImage: viewModel.otherUserAvatarImage ?? UIImage())
                //                cell.layoutSubviews()
                //                cell.layoutIfNeeded()
                
//                cell.delegate = self
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MyChatImageBubbleTableViewCell {
            let imageDetailViewController = ImageDetailViewController()
            tappedImageView = cell.imageMessageView
            tappedCell = cell
            
            imageDetailViewController.modalPresentationStyle = .custom
            imageDetailViewController.transitioningDelegate = self
            
            navigationController?.present(imageDetailViewController, animated: true)
            // self.present(imageDetailViewController, animated: true)
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? OtherChatImageBubbleTableViewCell {
            let imageDetailViewController = ImageDetailViewController()
            tappedImageView = cell.imageMessageView
            tappedCell = cell
            
            imageDetailViewController.modalPresentationStyle = .custom
            imageDetailViewController.transitioningDelegate = self
            
            navigationController?.present(imageDetailViewController, animated: true)
            // self.present(imageDetailViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
    }
}

extension ChatRoomViewController: ChatRoomViewModelDelegate {
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if !self.viewModel.messages.isEmpty {
                let indexPath = IndexPath(row: self.viewModel.messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
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

extension ChatRoomViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if !results.isEmpty {
            let result = results.first!
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    guard let image = image as? UIImage, let self = self else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.imageView.image = image
                        self.viewModel.imageData = image.jpegData(compressionQuality: 0.6)
                        self.viewModel.imageSize = image.size
                        
                        let ratio = image.size.height / 200
                        
                        self.imageViewWidthCons?.constant = image.size.width / ratio
                        self.view.layoutIfNeeded()
                        
                        self.imageViewTopCons?.constant = -(self.imageView.frame.height + self.containerView.frame.height + 25)
                        self.isSendingImage = true
                        
                        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
                            self.chatTextView.alpha = 0
                            self.choosePhotoButton.alpha = 0
                            self.sendPicLabel.alpha = 1
                            self.view.layoutIfNeeded()
                        }
                    }
                }
            }
        }
    }
}

extension ChatRoomViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let navigationController = navigationController {
            popAnimator = ChatRoomVCPopAnimator(fromNav: navigationController)
        }
        
        return popAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let navigationController = navigationController {
            dismissAnimator = ChatRoomVCDismissAnimator(toNav: navigationController)
        }
        
        return dismissAnimator
    }
}

//extension ChatRoomViewController: MyChatImageBubbleTableViewCellDelegate, OtherChatImageBubbleTableViewCellDelegate {
//    func updateTableView1(cell: UITableViewCell) {
//        UIView.performWithoutAnimation {
//            tableView.beginUpdates()
//            if let indexPath = tableView.indexPath(for: cell) {
//                tableView.reloadRows(at: [indexPath], with: .none)
//            }
//            tableView.endUpdates()
//        }
//    }
//    
//    func updateTableView2(cell: UITableViewCell) {
//        UIView.performWithoutAnimation {
//            tableView.beginUpdates()
//            if let indexPath = tableView.indexPath(for: cell) {
//                tableView.reloadRows(at: [indexPath], with: .none)
//            }
//            tableView.endUpdates()
//        }
//    }
//}
