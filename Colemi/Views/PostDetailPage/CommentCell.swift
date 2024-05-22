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
        imageView.backgroundColor = ThemeColorProperty.darkColor.getColor()
        
        return imageView
    }()
    
    lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = ThemeFontProperty.GenSenRoundedTW_R.getFont(size: 14)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = "臭芭樂"
        
        return label
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = ThemeFontProperty.GenSenRoundedTW_R.getFont(size: 14)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }()
    
    func setUpUI() {
        contentView.addSubview(authorImageView)
        contentView.addSubview(authorNameLabel)
        contentView.addSubview(commentLabel)
        contentView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        
        NSLayoutConstraint.activate([
            authorImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            authorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            authorImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/10),
            authorImageView.widthAnchor.constraint(equalTo: authorImageView.heightAnchor),
            
            authorNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            authorNameLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 12),
            authorNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18),
            
            commentLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 10),
            commentLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 12),
            commentLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18),
            commentLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50),
            commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        authorImageView.layer.cornerRadius = authorImageView.frame.width / 2
    }
}

extension CommentCell {
    func update(comment: Comment) {
        commentLabel.text = comment.body
        authorNameLabel.text = comment.userName
        let url = URL(string: comment.avatarURL)
        authorImageView.kf.setImage(with: url)
        
        commentLabel.addLineSpacing()
    }
}
    
