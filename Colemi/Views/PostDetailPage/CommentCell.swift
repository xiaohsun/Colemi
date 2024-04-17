//
//  CommentCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/17/24.
//

import UIKit

class CommentCell: UITableViewCell {
    
    static let reuseIdentifier = "\(CommentCell.self)"
    
    lazy var authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        
        return imageView
    }()
    
    lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.text = "臭芭樂"
        
        return label
    }()
    
    lazy var commentLabel: UILabel = {
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
        contentView.addSubview(commentLabel)
        
        NSLayoutConstraint.activate([
            authorImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            authorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            authorImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            authorImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/10),
            authorImageView.widthAnchor.constraint(equalTo: authorImageView.heightAnchor),
            
            authorNameLabel.centerYAnchor.constraint(equalTo: authorImageView.centerYAnchor),
            authorNameLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 12),
            
            commentLabel.centerYAnchor.constraint(equalTo: authorNameLabel.centerYAnchor),
            commentLabel.leadingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor, constant: 12)
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

extension CommentCell {
    func update(content: Content) {
        
    }
}
    
