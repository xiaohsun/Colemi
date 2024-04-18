//
//  SelectorHeaderView.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit

class SelectorHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "\(SelectorHeaderView.self)"
    
    lazy var postsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "貼文"
        
        return label
    }()
    
    lazy var savesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "收藏"
        
        return label
    }()
    
    func setUpUI() {
        contentView.addSubview(postsLabel)
        contentView.addSubview(savesLabel)
        contentView.layer.cornerRadius = 20
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.backgroundColor = UIColor(hex: "#F9F4E8")
        
        NSLayoutConstraint.activate([
            postsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            postsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 100),
            postsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            savesLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            savesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -100),
            savesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
