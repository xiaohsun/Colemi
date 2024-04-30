//
//  PostDetailViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/17/24.
//

import UIKit
import FirebaseFirestore

class PostDetailViewController: UIViewController {
    
    let viewModel = PostDetailViewModel()
    var contentJSONString = ""
    var photoImage: UIImage?
    var content: Content?
    let userData = UserManager.shared
    var postID = ""
    var authorID = ""
    var imageUrl = ""
    var post: Post?
    var comments: [Comment] = []
    let textViewMaxHeight: CGFloat = 100
    var headerView: DetailTableViewHeaderView?
    
    var commentTextViewTrailing: NSLayoutConstraint?
    var commentTextViewHeight: NSLayoutConstraint?
    
    var xPosition: CGFloat = 0
    var yPosition: CGFloat = 0
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        return tableView
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont(name: FontProperty.GenSenRoundedTW_B.rawValue, size: 14)
        button.backgroundColor = ThemeColorProperty.darkColor.getColor()
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        button.setTitleColor(ThemeColorProperty.lightColor.getColor(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        return button
    }()
    
    @objc private func sendButtonTapped() {
        viewModel.updateComments(commentText: commentTextView.text)
        tableView.reloadData()
        commentTextView.resignFirstResponder()
        commentTextView.text = ""
        
        UIView.animate(withDuration: 0.3) {
            self.commentTextViewTrailing?.constant = -10
            self.commentTextViewHeight?.constant = 33
            self.sendButton.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = ThemeColorProperty.darkColor.getColor().cgColor
        textView.layer.borderWidth = 1.5
        textView.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        textView.backgroundColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: FontProperty.GenSenRoundedTW_R.rawValue, size: 14)
        textView.delegate = self
        
        return textView
    }()
    
    lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = ThemeColorProperty.darkColor.getColor()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(starTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    @objc private func starTapped(_ sender: UITapGestureRecognizer) {
        if userData.savedPosts.contains(postID) {
            userData.savedPosts.removeAll { $0 == postID }
            starImageView.image = UIImage(systemName: "star")
            Task {
                await viewModel.updateSavedPosts(savedPostsArray: userData.savedPosts, postID: postID, docID: userData.id)
            }
        } else {
            userData.savedPosts.append(postID)
            starImageView.image = UIImage(systemName: "star.fill")
            Task {
                await viewModel.updateSavedPosts(savedPostsArray: userData.savedPosts, postID: postID, docID: userData.id)
            }
        }
    }
    
    private func setUpStarImageView() {
        if userData.savedPosts.contains(postID) {
            starImageView.image = UIImage(systemName: "star.fill")
        } else {
            starImageView.image = UIImage(systemName: "star")
        }
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    private func setUpUI() {
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        view.addSubview(tableView)
        view.addSubview(commentTextView)
        view.addSubview(starImageView)
        view.addSubview(sendButton)
        view.layer.cornerRadius = 30
        setUpStarImageView()
        
        commentTextViewTrailing = commentTextView.trailingAnchor.constraint(equalTo: starImageView.leadingAnchor, constant: -10)
        commentTextViewTrailing?.isActive = true
        
        commentTextViewHeight = commentTextView.heightAnchor.constraint(equalToConstant: 33)
        commentTextViewHeight?.isActive = true
        
        tableView.register(DetailTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: DetailTableViewHeaderView.reuseIdentifier)
        tableView.register(AuthorInfoAndTitleCell.self, forCellReuseIdentifier: AuthorInfoAndTitleCell.reuseIdentifier)
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: DescriptionCell.reuseIdentifier)
        tableView.register(TagCell.self, forCellReuseIdentifier: TagCell.reuseIdentifier)
        tableView.register(SeperatorCell.self, forCellReuseIdentifier: SeperatorCell.reuseIdentifier)
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: commentTextView.topAnchor),
            
            commentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            commentTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            
            sendButton.heightAnchor.constraint(equalToConstant: 33),
            sendButton.trailingAnchor.constraint(equalTo: starImageView.leadingAnchor, constant: -12),
            sendButton.leadingAnchor.constraint(equalTo: commentTextView.trailingAnchor, constant: 12),
            sendButton.bottomAnchor.constraint(equalTo: commentTextView.bottomAnchor),
            
            starImageView.heightAnchor.constraint(equalToConstant: 30),
            starImageView.widthAnchor.constraint(equalToConstant: 30),
            starImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            starImageView.bottomAnchor.constraint(equalTo: commentTextView.bottomAnchor, constant: -2)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        viewModel.decodeContent(jsonString: contentJSONString) { [weak self] content in
            guard let self = self else { return }
            self.content = content
        }
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 3
        } else {
            return viewModel.comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let content = content else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AuthorInfoAndTitleCell.reuseIdentifier, for: indexPath) as? AuthorInfoAndTitleCell else { return UITableViewCell() }
            
            cell.delegate = self
            cell.update(content: content)
            
            return cell
            
        } else if indexPath.section == 1 {
            switch indexPath.item {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.reuseIdentifier, for: indexPath) as? DescriptionCell else { return UITableViewCell() }
                
                cell.update(content: content)
                
                return cell
                
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TagCell.reuseIdentifier, for: indexPath) as? TagCell else { return UITableViewCell() }
                
                cell.update(content: content)
                
                return cell
                
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SeperatorCell.reuseIdentifier, for: indexPath) as? SeperatorCell else { return UITableViewCell() }
                
                return cell
            default:
                return UITableViewCell()
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseIdentifier, for: indexPath) as? CommentCell else { return UITableViewCell() }
            let comment = viewModel.comments[indexPath.item]
            cell.update(comment: comment)
            
            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailTableViewHeaderView.reuseIdentifier) as? DetailTableViewHeaderView else { return nil }
            // if let photoImage = photoImage {
            self.headerView = headerView
            let url = URL(string: imageUrl)
            headerView.photoImageView.kf.setImage(with: url)
            // }
            // headerView.photoImageView.image?.size.height
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
            headerView.addGestureRecognizer(tapGesture)
            headerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
            
            
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let post = viewModel.post, section == 0 else { return 0 }
        let portion = post.imageWidth / view.frame.width
        
        return post.imageHeight / portion
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension PostDetailViewController: AuthorInfoAndTitleCellDelegate {
    func pushToAuthorProfilePage() {
        // let navigationController = UINavigationController(rootViewController: self)
        let profileViewController = ProfileViewController()
        
        if authorID == userData.id {
            present(profileViewController, animated: true)
        } else {
            
            let firestoreManager = FirestoreManager.shared
            let ref = FirestoreEndpoint.users.ref
            
            
            Task {
                let userData: User? = await firestoreManager.getSpecificDocument(collection: ref, docID: authorID)
                
                if let userData = userData {
                    
                    profileViewController.isOthersPage = true
                    profileViewController.otherUserData = userData
                    // navigationController.pushViewController(profileViewController, animated: true)
                    present(profileViewController, animated: true)
                }
            }
        }
    }
}

extension PostDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: commentTextView.frame.size.width, height: .infinity)
        let estimatedSize = commentTextView.sizeThatFits(size)
        
        guard commentTextView.contentSize.height < 100 else {
            commentTextView.isScrollEnabled = true
            return
        }
        
        commentTextView.isScrollEnabled = false
        commentTextViewHeight?.constant = estimatedSize.height
        
        if textView.text != "" {
            UIView.animate(withDuration: 0.3) {
                self.commentTextViewTrailing?.constant = -80
                self.sendButton.alpha = 1
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.commentTextViewTrailing?.constant = -10
                self.sendButton.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension PostDetailViewController {
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        var startPoint = self.view.transform
        if gesture.state == .began {
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            let transform = CGAffineTransform(translationX: translation.x, y: translation.y)
            // headerView?.photoImageView.transform = transform
            view.transform = transform
            // self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            
        } else if gesture.state == .ended {
            if abs(gesture.translation(in: self.view).x) >= 100 {
                xPosition = gesture.translation(in: self.view).x
                yPosition = gesture.translation(in: self.view).y + 60
                dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.4) {
                    // self.headerView?.photoImageView.transform = .identity
                    self.view.transform = .identity
                    // startPoint = CGAffineTransform(translationX: 0, y: self.view.safeAreaLayoutGuide.layoutFrame.origin.y)
                    // self.view.transform = startPoint
                }
            }
        }
    }
}
