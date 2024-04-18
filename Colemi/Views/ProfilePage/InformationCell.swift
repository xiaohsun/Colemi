//
//  InformationCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit

class InformationCell: UITableViewCell {
    
    static let reuseIdentifier = "\(InformationCell.self)"
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.text = "勳仔子"
        
        return label
    }()
    
    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.text = "xiaohsun"
        
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        
        return imageView
    }()
    
    lazy var fansLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.text = "粉絲"
        
        return label
    }()
    
    lazy var fansNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.text = "999"
        
        return label
    }()
    
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.text = "追蹤中"
        
        return label
    }()
    
    lazy var followingNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.text = "50"
        
        return label
    }()
    
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
    
    func setUpUI() {
        contentView.backgroundColor = UIColor(hex: "#F9F4E8")
        collectionView.backgroundColor = UIColor(hex: "#F9F4E8")
        contentView.addSubview(nameLabel)
        contentView.addSubview(idLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(fansLabel)
        contentView.addSubview(fansNumberLabel)
        contentView.addSubview(followingLabel)
        contentView.addSubview(followingNumberLabel)
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            nameLabel.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: -50),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            idLabel.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor),
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            fansLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            fansLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 30),
            
            fansNumberLabel.centerXAnchor.constraint(equalTo: fansLabel.centerXAnchor),
            fansNumberLabel.topAnchor.constraint(equalTo: fansLabel.bottomAnchor, constant: 10),
            
            followingLabel.leadingAnchor.constraint(equalTo: fansLabel.trailingAnchor, constant: 30),
            followingLabel.centerYAnchor.constraint(equalTo: fansLabel.centerYAnchor),
            
            followingNumberLabel.centerXAnchor.constraint(equalTo: followingLabel.centerXAnchor),
            followingNumberLabel.centerYAnchor.constraint(equalTo: fansNumberLabel.centerYAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 35),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setUpUI()
        collectionView.register(TextViewCell.self, forCellWithReuseIdentifier: TextViewCell.reuseIdentifier)
        collectionView.register(FollowOrEditInfoCell.self, forCellWithReuseIdentifier: FollowOrEditInfoCell.reuseIdentifier)
        collectionView.register(ColorFootprintCell.self, forCellWithReuseIdentifier: ColorFootprintCell.reuseIdentifier)
        collectionView.register(BestColorCell.self, forCellWithReuseIdentifier: BestColorCell.reuseIdentifier)
        collectionView.register(AchievementCell.self, forCellWithReuseIdentifier: AchievementCell.reuseIdentifier)
        configureDataSource()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InformationCell {
    func update(content: Content) {
    }
}

extension InformationCell {
    func configureLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            if sectionIndex == 0 {
                let leftItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0))
                let rightItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
                
                let leftItem = NSCollectionLayoutItem(layoutSize: leftItemSize)
                let rightItem = NSCollectionLayoutItem(layoutSize: rightItemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.35))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [leftItem, rightItem])
                
                //group.interItemSpacing = .fixed(20)
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 20, trailing: 10)
                
                return section
                
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.35))
                
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
                switch indexPath.row {
                case 0:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextViewCell.reuseIdentifier, for: indexPath) as? TextViewCell else { fatalError("Can't create new cell") }
                    
                    return cell
                default:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowOrEditInfoCell.reuseIdentifier, for: indexPath) as? FollowOrEditInfoCell else { fatalError("Can't create new cell") }
                    
                    return cell
                }
                
            } else {
                switch indexPath.row {
                case 0:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorFootprintCell.reuseIdentifier, for: indexPath) as? ColorFootprintCell else { fatalError("Can't create new cell") }
                    
                    return cell
                case 1:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BestColorCell.reuseIdentifier, for: indexPath) as? BestColorCell else { fatalError("Can't create new cell") }
                    
                    return cell
                default:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AchievementCell.reuseIdentifier, for: indexPath) as? AchievementCell else { fatalError("Can't create new cell") }
                    
                    return cell
                    
                }
            }
        }
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        initialSnapshot.appendSections([.top, .bottom])
        initialSnapshot.appendItems(Array(1...2), toSection: .top)
        initialSnapshot.appendItems(Array(3...5), toSection: .bottom)
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
}