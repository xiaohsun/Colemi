//
//  InformationCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//
// swiftlint:disable cyclomatic_complexity

import UIKit
import Kingfisher

class InformationCell: UITableViewCell {
    
    static let reuseIdentifier = "\(InformationCell.self)"
    var isOthersPage: Bool = false
    
    let viewModel = InformationCellViewModel()
    var viewController: ProfileViewController?
    
    weak var delegate: InformationCellDelegate?
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 14)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = "Hello"
        
        return label
    }()
    
    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 18)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = ""
        
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = ThemeColorProperty.darkColor.getColor()
        
        return imageView
    }()
    
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 14)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = "粉絲"
        addFollowerTappedGes(label: label, action: #selector(followersTapped))
        
        return label
    }()
    
    lazy var followersNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 18)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = "999"
        addFollowerTappedGes(label: label, action: #selector(followersTapped))
        
        return label
    }()
    
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 14)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = "追蹤中"
        addFollowerTappedGes(label: label, action: #selector(followingTapped))
        
        return label
    }()
    
    lazy var followingNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = ThemeFontProperty.GenSenRoundedTW_B.getFont(size: 18)
        label.textColor = ThemeColorProperty.darkColor.getColor()
        label.text = "50"
        addFollowerTappedGes(label: label, action: #selector(followingTapped))
        
        return label
    }()
    
    private func addFollowerTappedGes(label: UILabel, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
    }
    
    @objc private func followersTapped() {
        delegate?.pushToFollowVC(isFollowersTapped: true)
    }
    
    @objc private func followingTapped() {
        delegate?.pushToFollowVC(isFollowersTapped: false)
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    enum Section {
        case top
        case bottom
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>?
    
    func setupUI() {
        contentView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        collectionView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        contentView.addSubview(nameLabel)
        contentView.addSubview(idLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(followersLabel)
        contentView.addSubview(followersNumberLabel)
        contentView.addSubview(followingLabel)
        contentView.addSubview(followingNumberLabel)
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            nameLabel.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: -50),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            idLabel.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor),
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            followersLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            followersLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 40),
            
            followersNumberLabel.centerXAnchor.constraint(equalTo: followersLabel.centerXAnchor),
            followersNumberLabel.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 10),
            
            followingLabel.leadingAnchor.constraint(equalTo: followersLabel.trailingAnchor, constant: 30),
            followingLabel.centerYAnchor.constraint(equalTo: followersLabel.centerYAnchor),
            
            followingNumberLabel.centerXAnchor.constraint(equalTo: followingLabel.centerXAnchor),
            followingNumberLabel.centerYAnchor.constraint(equalTo: followersNumberLabel.centerYAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 35),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
        collectionView.register(TextViewCell.self, forCellWithReuseIdentifier: TextViewCell.reuseIdentifier)
        collectionView.register(FollowOrEditInfoCell.self, forCellWithReuseIdentifier: FollowOrEditInfoCell.reuseIdentifier)
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.reuseIdentifier)
        collectionView.register(ColorFootprintCell.self, forCellWithReuseIdentifier: ColorFootprintCell.reuseIdentifier)
        collectionView.register(CollectedColorCell.self, forCellWithReuseIdentifier: CollectedColorCell.reuseIdentifier)
        collectionView.register(AchievementCell.self, forCellWithReuseIdentifier: AchievementCell.reuseIdentifier)
        collectionView.delegate = self
        // configureDataSource()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSelfPageCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextViewCell.reuseIdentifier, for: indexPath) as? TextViewCell else {
                fatalError("Can't create new cell")
            }
            cell.delegate = self
            cell.update(description: self.viewModel.userData.description, isOthersPage: self.isOthersPage)
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowOrEditInfoCell.reuseIdentifier, for: indexPath) as? FollowOrEditInfoCell else {
                fatalError("Can't create new cell")
            }
            cell.changeToSetting()
            cell.delegate = self
            return cell
        }
    }
    
    private func configureOthersPageCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextViewCell.reuseIdentifier, for: indexPath) as? TextViewCell else {
                fatalError("Can't create new cell")
            }
            cell.delegate = self
            cell.update(description: self.viewModel.otherUserData?.description ?? "", isOthersPage: self.isOthersPage)
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowOrEditInfoCell.reuseIdentifier, for: indexPath) as? FollowOrEditInfoCell else {
                fatalError("Can't create new cell")
            }
            let isFollowing = self.viewModel.userData.following.contains(self.viewModel.otherUserData?.id ?? "")
            cell.changeToFollow(isFollowing: isFollowing)
            cell.delegate = self
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCell.reuseIdentifier, for: indexPath) as? ChatCell else {
                fatalError("Can't create new cell")
            }
            cell.delegate = self
            cell.viewModel.otherUserData = self.viewModel.otherUserData
            return cell
        }
    }
}

extension InformationCell {
    func update(name: String, followers: [String], following: [String], isOthersPage: Bool, avatarUrl: String) {
        idLabel.text = name
        followersNumberLabel.text = "\(followers.count)"
        followingNumberLabel.text = "\(following.count)"
        let url = URL(string: avatarUrl)
        avatarImageView.kf.setImage(with: url)
        self.isOthersPage = isOthersPage
        
        configureDataSource()
    }
}

extension InformationCell {
    func configureLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            if sectionIndex == 0 && !self.isOthersPage {
                let leftItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0))
                let rightItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
                
                let leftItem = NSCollectionLayoutItem(layoutSize: leftItemSize)
                let rightItem = NSCollectionLayoutItem(layoutSize: rightItemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [leftItem, rightItem])
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 20, trailing: 10)
                
                return section
                
            } else if sectionIndex == 0 && self.isOthersPage {
                
                let leftItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0))
                let leftItem = NSCollectionLayoutItem(layoutSize: leftItemSize)
                
                let rightItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
                
                
                let rightTopItem = NSCollectionLayoutItem(layoutSize: rightItemSize)
                let rightBottomItem = NSCollectionLayoutItem(layoutSize: rightItemSize)
                
                let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
                
                let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [rightTopItem, rightBottomItem])
                
                verticalGroup.interItemSpacing = .fixed(10)
                
                let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33))
                
                let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [leftItem, verticalGroup])
                
                let section = NSCollectionLayoutSection(group: containerGroup)
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 20, trailing: 10)
                
                return section
                
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                // group.interItemSpacing = .fixed(20)
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10)
                
                return section
            }
        }
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        return layout
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: self.collectionView) { (collectionView, indexPath, _) -> UICollectionViewCell? in
            
            if indexPath.section == 0 {
                
                if self.isOthersPage {
                    return self.configureOthersPageCell(collectionView: collectionView, indexPath: indexPath)
                } else {
                    return self.configureSelfPageCell(collectionView: collectionView, indexPath: indexPath)
                }
                
            } else {
                switch indexPath.row {
                case 0:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorFootprintCell.reuseIdentifier, for: indexPath) as? ColorFootprintCell else { fatalError("Can't create new cell") }
                    
                    if self.isOthersPage {
                        cell.update(colorPoints: self.viewModel.otherUserData?.colorPoints ?? 0)
                    } else {
                        cell.update(colorPoints: self.viewModel.userData.colorPoints)
                    }
                    
                    return cell
                case 1:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectedColorCell.reuseIdentifier, for: indexPath) as? CollectedColorCell else { fatalError("Can't create new cell") }
                    
                    return cell
                default:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AchievementCell.reuseIdentifier, for: indexPath) as? AchievementCell else { fatalError("Can't create new cell") }
                    
                    return cell
                }
            }
        }
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        initialSnapshot.appendSections([.top, .bottom])
        
        if !self.isOthersPage {
            initialSnapshot.appendItems(Array(1...2), toSection: .top)
            initialSnapshot.appendItems(Array(3...5), toSection: .bottom)
        } else {
            initialSnapshot.appendItems(Array(1...1), toSection: .top)
            initialSnapshot.appendItems(Array(2...3), toSection: .top)
            initialSnapshot.appendItems(Array(4...6), toSection: .bottom)
        }
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
}

extension InformationCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = viewController else { return }
        
        if indexPath == IndexPath(row: 0, section: 1) {
            let colorFootprintPopUp = ColorFootprintPopUp()
            colorFootprintPopUp.appear(sender: vc)
        } else if indexPath == IndexPath(row: 1, section: 1) {
            let collectedColorPopUp = CollectedColorPopUp()
            if isOthersPage {
                collectedColorPopUp.collectedColors = viewModel.otherUserData?.collectedColors ?? []
            } else {
                collectedColorPopUp.collectedColors = viewModel.userData.collectedColors
            }
            collectedColorPopUp.appear(sender: vc)
        } else {
            let achievementPopUp = AchievementPopUp()
            achievementPopUp.appear(sender: vc)
        }
    }
}

extension InformationCell: FollowOrEditInfoCellDelegate {
    func updateFollower() {
        guard let otherUserFollowers = viewModel.otherUserFollowers else { return }
        viewModel.updateFollower { otherUserFollowers, isFollowing in
            DispatchQueue.main.async {
                self.followersNumberLabel.text = "\(otherUserFollowers.count)"
                let indexPath = IndexPath(row: 1, section: 0)
                let cell = self.collectionView.cellForItem(at: indexPath) as? FollowOrEditInfoCell
                cell?.button.setTitle(isFollowing ? "取消追蹤": "追蹤", for: .normal)
            }
        }
    }
    
    func pushToSettingVC() {
        delegate?.pushToSettingVC()
    }
}

extension InformationCell: TextViewCellDelegate {
    func userDescriptionChange(text: String) {
        viewModel.updateUserDescription(text: text)
    }
}

extension InformationCell: ChatCellDelegate {
    func pushToChatRoom(chatRoomID: String) {
        delegate?.pushToChatRoom(chatRoomID: chatRoomID, avatarImage: avatarImageView.image ?? UIImage())
    }
}

protocol InformationCellDelegate: AnyObject {
    func pushToSettingVC()
    func pushToChatRoom(chatRoomID: String, avatarImage: UIImage)
    func pushToFollowVC(isFollowersTapped: Bool)
}
