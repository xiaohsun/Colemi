//
//  PostDetailViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/17/24.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    let viewModel = PostDetailViewModel()
    var contentJSONString = ""
    var photoImage: UIImage?
    var content: Content?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        return tableView
    }()
    
    lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1.5
        textView.layer.cornerRadius = 10
        textView.backgroundColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(commentTextView)
        
        tableView.register(DetailTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: DetailTableViewHeaderView.reuseIdentifier)
        tableView.register(AuthorInfoAndTitleCell.self, forCellReuseIdentifier: AuthorInfoAndTitleCell.reuseIdentifier)
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: DescriptionCell.reuseIdentifier)
        tableView.register(TagCell.self, forCellReuseIdentifier: TagCell.reuseIdentifier)
        tableView.register(SeperatorCell.self, forCellReuseIdentifier: SeperatorCell.reuseIdentifier)
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: commentTextView.topAnchor),
            
            commentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            commentTextView.heightAnchor.constraint(equalToConstant: 40),
            commentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            commentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        viewModel.delegate = self
        viewModel.decodeContent(jsonString: contentJSONString)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
}

extension PostDetailViewController: PostDetailViewModelDelegate {
    func passContentData(content: Content) {
        self.content = content
        // let url = URL(string: content.imgURL)
        //        photoImageView.kf.setImage(with: url)
        //        authorNameLabel.text = content.authorName
        //        titleLabel.text = "- \(content.title)"
        //        descriptionLabel.text = content.description
    }
}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 3
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let content = content else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AuthorInfoAndTitleCell.reuseIdentifier, for: indexPath) as? AuthorInfoAndTitleCell else { return UITableViewCell() }
            
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
            
            cell.update(content: content)
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailTableViewHeaderView.reuseIdentifier) as? DetailTableViewHeaderView else { return nil }
            if let photoImage = photoImage {
                headerView.photoImageView.image = photoImage
            }
            
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // photoImage?.size.height ??
        if section == 0 {
            500
        } else {
            0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
