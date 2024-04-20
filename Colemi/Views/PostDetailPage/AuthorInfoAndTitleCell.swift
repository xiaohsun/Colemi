//
//  AuthorInfoAndTitleCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/17/24.
//

import UIKit

class AuthorInfoAndTitleCell: UITableViewCell {
    
    weak var delegate: AuthorInfoAndTitleCellDelegate?
    static let reuseIdentifier = "\(AuthorInfoAndTitleCell.self)"
    var content: Content?
    
    lazy var authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(authorTapped))
        imageView.addGestureRecognizer(tapGesture)
        
        return imageView
    }()
    
    lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(authorTapped))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()
    
    @objc private func authorTapped(_ sender: UITapGestureRecognizer) {
        print("Hi")
        delegate?.pushToAuthorProfilePage()
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        
        return label
    }()
    
    func setUpUI() {
        contentView.addSubview(authorImageView)
        contentView.addSubview(authorNameLabel)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            
            authorImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            authorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            authorImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            authorImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/10),
            authorImageView.widthAnchor.constraint(equalTo: authorImageView.heightAnchor),
            
            authorNameLabel.centerYAnchor.constraint(equalTo: authorImageView.centerYAnchor),
            authorNameLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 12),
            
            titleLabel.centerYAnchor.constraint(equalTo: authorNameLabel.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor, constant: 12)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        authorImageView.layer.cornerRadius = authorImageView.frame.width / 2
    }
}

extension AuthorInfoAndTitleCell {
    func update(content: Content) {
        self.content = content
        authorNameLabel.text = content.authorName
        titleLabel.text = content.title
    }
}

protocol AuthorInfoAndTitleCellDelegate: AnyObject {
    func pushToAuthorProfilePage()
}
    
