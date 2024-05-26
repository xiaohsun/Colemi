//
//  ChatRoomViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit
import PhotosUI

class ChatRoomViewController: UIViewController {
    
    let viewModel = ChatRoomViewModel()
    
    let textViewInitHeight: CGFloat = 33
    var chatTextViewHeightCons: NSLayoutConstraint?
    var imageViewTopCons: NSLayoutConstraint?
    var imageViewWidthCons: NSLayoutConstraint?
    var tappedImageView: UIImageView?
    var tappedCell: UITableViewCell?
    
    var isSendingImage: Bool = false
    var isPageLoadFirstTime: Bool = true
    
    var popAnimator: ChatRoomVCPopAnimator?
    var dismissAnimator: ChatRoomVCDismissAnimator?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MyChatTextBubbleTableViewCell.self, forCellReuseIdentifier: MyChatTextBubbleTableViewCell.reuseIdentifier)
        tableView.register(MyChatImageBubbleTableViewCell.self, forCellReuseIdentifier: MyChatImageBubbleTableViewCell.reuseIdentifier)
        tableView.register(OtherChatTextBubbleTableViewCell.self, forCellReuseIdentifier: OtherChatTextBubbleTableViewCell.reuseIdentifier)
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
        chatTextView.font = ThemeFontProperty.GenSenRoundedTW_R.getFont(size: 16)
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
    
    lazy var cancelPicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = ThemeColorProperty.darkColor.getColor()
        imageView.image = UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelPicture))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        imageView.alpha = 0
        
        return imageView
    }()
    
    lazy var sendPicLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "傳送圖片"
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 18)
        label.textColor = .white
        label.alpha = 0
        
        return label
    }()
    
    lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        
        return imageView
    }()
    
    private func dismissPictureView() {
        view.endEditing(true)
        imageViewTopCons?.constant = 0
        self.pictureUpDownAnimation(isSendingImage: false)
    }
    
    private func showPictureView(image: UIImage) {
        let ratio = image.size.height / 200
        self.imageViewWidthCons?.constant = image.size.width / ratio
        self.view.layoutIfNeeded()
        
        self.imageViewTopCons?.constant = -(self.pictureImageView.frame.height + self.containerView.frame.height + 25)
        
        self.pictureUpDownAnimation(isSendingImage: true)
    }
    
    private func pictureUpDownAnimation(isSendingImage: Bool) {
        self.isSendingImage = isSendingImage
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8) {
            self.chatTextView.alpha = isSendingImage ? 0 : 1
            self.choosePhotoButton.alpha = isSendingImage ? 0 : 1
            self.sendPicLabel.alpha = isSendingImage ? 1 : 0
            self.cancelPicImageView.alpha = isSendingImage ? 1 : 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func sendMessageButtonTapped() {
        if !isSendingImage && chatTextView.text != "" {
            Task {
                await viewModel.updateUsersSimpleChatRoom(latestMessage: chatTextView.text, type: 0)
                DispatchQueue.main.async {
                    self.chatTextView.text = ""
                    self.view.endEditing(true)
                }
            }
            
        } else {
            guard let imageData = viewModel.imageData, let imageSize = viewModel.imageSize else { return }
            
            viewModel.uploadImgToFirebase(imageData: imageData, imageSize: imageSize)
            
            DispatchQueue.main.async {
                self.dismissPictureView()
            }
        }
    }
    
    @objc private func choosePicButtonTapped() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    @objc private func cancelPicture() {
        dismissPictureView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = ThemeColorProperty.lightColor.getColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(popNav))
        navigationItem.leftBarButtonItem?.tintColor = ThemeColorProperty.darkColor.getColor()
        navigationItem.title = viewModel.otherUserName
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 18), NSAttributedString.Key.foregroundColor: ThemeColorProperty.darkColor.getColor()]
    }
    
    @objc private func popNav() {
        navigationController?.popViewController(animated: true)
    }
    
    private func presentImageDetailViewController(cell: UITableViewCell, imageMessageView: UIImageView) {
        let imageDetailViewController = ImageDetailViewController()
        tappedImageView = imageMessageView
        tappedCell = cell
        
        imageDetailViewController.modalPresentationStyle = .custom
        imageDetailViewController.transitioningDelegate = self
        
        navigationController?.present(imageDetailViewController, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        view.addSubview(tableView)
        view.addSubview(containerView)
        view.addSubview(pictureImageView)
        view.addSubview(cancelPicImageView)
        containerView.addSubview(chatTextView)
        containerView.addSubview(sendMessageButton)
        containerView.addSubview(choosePhotoButton)
        containerView.addSubview(sendPicLabel)
        
        tabBarController?.tabBar.isHidden = true
        setupNavigationBar()
        chatTextViewInit()
        
        chatTextViewHeightCons = chatTextView.heightAnchor.constraint(equalToConstant: textViewInitHeight)
        chatTextViewHeightCons?.isActive = true
        
        imageViewTopCons = pictureImageView.topAnchor.constraint(equalTo: view.bottomAnchor)
        imageViewTopCons?.isActive = true
        
        imageViewWidthCons = pictureImageView.widthAnchor.constraint(equalToConstant: 200)
        imageViewWidthCons?.isActive = true
        
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
            choosePhotoButton.heightAnchor.constraint(equalToConstant: 22),
            choosePhotoButton.widthAnchor.constraint(equalTo: choosePhotoButton.heightAnchor),
            choosePhotoButton.centerYAnchor.constraint(equalTo: sendMessageButton.centerYAnchor),
            
            pictureImageView.heightAnchor.constraint(equalToConstant: 200),
            pictureImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            cancelPicImageView.trailingAnchor.constraint(equalTo: pictureImageView.trailingAnchor, constant: 12.5),
            cancelPicImageView.topAnchor.constraint(equalTo: pictureImageView.topAnchor, constant: -12.5),
            cancelPicImageView.widthAnchor.constraint(equalToConstant: 25),
            cancelPicImageView.heightAnchor.constraint(equalTo: cancelPicImageView.widthAnchor),
            
            sendPicLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendPicLabel.centerYAnchor.constraint(equalTo: sendMessageButton.centerYAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.delegate = self
        viewModel.getDetailedChatRoomDataRealTime(chatRoomID: viewModel.chatRoomID)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cancelPicImageView.layer.cornerRadius = cancelPicImageView.frame.width / 2
    }
}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let isSenderMyself = viewModel.messages[indexPath.item].senderID == viewModel.userData.id
        let isMessageTypeText = viewModel.messages[indexPath.item].type == 0
        let message = viewModel.messages[indexPath.item]
        
        if isSenderMyself && isMessageTypeText {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatTextBubbleTableViewCell.reuseIdentifier, for: indexPath) as? MyChatTextBubbleTableViewCell else { return UITableViewCell() }
            
            cell.update(messageData: message)
            
            return cell
            
        } else if isSenderMyself && !isMessageTypeText {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatImageBubbleTableViewCell.reuseIdentifier, for: indexPath) as? MyChatImageBubbleTableViewCell else { return UITableViewCell() }
            
            cell.update(messageData: message)
            cell.delegate = self
            
            return cell
            
        } else if !isSenderMyself && isMessageTypeText {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherChatTextBubbleTableViewCell.reuseIdentifier, for: indexPath) as? OtherChatTextBubbleTableViewCell
            else { return UITableViewCell() }
            
            cell.update(messageData: message, avatarImage: viewModel.otherUserAvatarImage ?? UIImage())
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherChatImageBubbleTableViewCell.reuseIdentifier, for: indexPath) as? OtherChatImageBubbleTableViewCell
            else { return UITableViewCell() }
            
            cell.update(messageData: message, avatarImage: viewModel.otherUserAvatarImage ?? UIImage())
            cell.delegate = self
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MyChatImageBubbleTableViewCell {
            presentImageDetailViewController(cell: cell, imageMessageView: cell.imageMessageView)
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? OtherChatImageBubbleTableViewCell {
            presentImageDetailViewController(cell: cell, imageMessageView: cell.imageMessageView)
        }
    }
    
    // 可能可以刪掉
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
    }
}

extension ChatRoomViewController: ChatRoomViewModelDelegate {
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let havePastMessages = !self.viewModel.messages.isEmpty
            let indexPath = IndexPath(row: self.viewModel.messages.count - 1, section: 0)
            
            if havePastMessages && self.isPageLoadFirstTime {
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                self.isPageLoadFirstTime = false
                
            } else if havePastMessages && !self.isPageLoadFirstTime {
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
                        self.pictureImageView.image = image
                        self.viewModel.imageData = image.jpegData(compressionQuality: 0.6)
                        self.viewModel.imageSize = image.size
                        
                        self.showPictureView(image: image)
                        self.pictureUpDownAnimation(isSendingImage: true)
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

extension ChatRoomViewController: MyChatImageBubbleTableViewCellDelegate, OtherChatImageBubbleTableViewCellDelegate {
    // 完全沒被執行到
    func updateTableView1(cell: UITableViewCell) {
        //        view.layoutIfNeeded()
        //        tableView.layoutIfNeeded()
        // UIView.performWithoutAnimation {
        //            tableView.beginUpdates()
        ////            if let indexPath = tableView.indexPath(for: cell) {
        ////                tableView.reloadRows(at: [indexPath], with: .none)
        ////            }
        ////            view.layoutIfNeeded()
        ////            tableView.layoutIfNeeded()
        //            tableView.endUpdates()
        //}
    }
    
    func updateTableView2(cell: UITableViewCell) {
        //        view.layoutIfNeeded()
        //        tableView.layoutIfNeeded()
        
        //UIView.performWithoutAnimation {
        //            tableView.beginUpdates()
        ////            if let indexPath = tableView.indexPath(for: cell) {
        ////                tableView.reloadRows(at: [indexPath], with: .none)
        ////            }
        ////            view.layoutIfNeeded()
        ////            tableView.layoutIfNeeded()
        //            tableView.endUpdates()
        // }
    }
}
