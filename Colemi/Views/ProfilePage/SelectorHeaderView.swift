//
//  SelectorHeaderView.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit

class SelectorHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "\(SelectorHeaderView.self)"
    weak var delegate: SelectorHeaderViewDelegate?
    
    // let viewModel = ProfileViewModel()
    var isShowingMyPosts = true
    
    lazy var postsButton: UIButton = {
        let button = UIButton()
        button.isSelected = true
        button.setTitleColor(ThemeColorProperty.darkColor.getColor(), for: .selected)
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitle("貼文", for: .normal)
        button.titleLabel?.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 18)
        button.addTarget(self, action: #selector(buttonGetTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var savesButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ThemeColorProperty.darkColor.getColor(), for: .selected)
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitle("收藏", for: .normal)
        button.titleLabel?.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 18)
        button.addTarget(self, action: #selector(buttonGetTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func buttonGetTapped(_ sender: UIButton) {
        switch sender {
        case postsButton:
            postsButton.isSelected = true
            savesButton.isSelected = false
            isShowingMyPosts = true
        case savesButton:
            postsButton.isSelected = false
            savesButton.isSelected = true
            isShowingMyPosts = false
        default:
            break
        }
        
        delegate?.changeShowingPostsOrSaved(isShowingMyPosts: isShowingMyPosts)
    }
    
    func setUpUI() {
        contentView.addSubview(postsButton)
        contentView.addSubview(savesButton)
        contentView.layer.cornerRadius = RadiusProperty.radiusTwenty.rawValue
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.backgroundColor = UIColor(hex: "#F9F4E8")
        
        NSLayoutConstraint.activate([
            postsButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            postsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            postsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            postsButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2),
            
            savesButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            savesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
            savesButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            savesButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2)
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

protocol SelectorHeaderViewDelegate: AnyObject {
    func changeShowingPostsOrSaved(isShowingMyPosts: Bool)
}
