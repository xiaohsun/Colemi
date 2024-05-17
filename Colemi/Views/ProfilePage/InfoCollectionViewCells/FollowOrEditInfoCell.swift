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
    
    @objc private func followBtnTapped(_ sender: UIButton) {
        delegate?.updateFollower()
    }
    
    @objc private func settingBtnTapped(_ sender: UIButton) {
        delegate?.pushToSettingVC()
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 14)
        button.backgroundColor = .white
        button.setTitleColor(ThemeColorProperty.darkColor.getColor(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension FollowOrEditInfoCell {
    func changeToSetting() {
        button.setTitle("設定", for: .normal)
        button.layer.cornerRadius = RadiusProperty.radiusTwenty.rawValue
        button.addTarget(self, action: #selector(settingBtnTapped), for: .touchUpInside)
    }
    
    func changeToFollow(isFollowing: Bool) {
        button.setTitle(isFollowing ? "取消追蹤" : "追蹤", for: .normal)
        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        button.addTarget(self, action: #selector(followBtnTapped), for: .touchUpInside)
    }
}

protocol FollowOrEditInfoCellDelegate: AnyObject {
    func updateFollower()
    func pushToSettingVC()
}
