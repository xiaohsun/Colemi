//
//  FollowOrEditInfoCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit

class FollowOrEditInfoCell: UICollectionViewCell {
    
    weak var delegate: FollowOrEditInfoCellDelegate?
    
    static let reuseIdentifier = "\(FollowOrEditInfoCell.self)"
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = RadiusProperty.radiusTwenty.rawValue
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(followBtnTapped))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    @objc private func followBtnTapped(_ sender: UITapGestureRecognizer) {
        print("followed!")
        delegate?.updateFollower()
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: FontProperty.GenSenRoundedTW_M.rawValue, size: 14)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = "追蹤"
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(followBtnTapped))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension FollowOrEditInfoCell {
    func update() {
        containerView.isUserInteractionEnabled = false
        label.isUserInteractionEnabled = false
    }
}

protocol FollowOrEditInfoCellDelegate: AnyObject {
    func updateFollower()
}
