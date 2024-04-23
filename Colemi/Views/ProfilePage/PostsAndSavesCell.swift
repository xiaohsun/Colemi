//
//  PostsAndSavesCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit

class PostsAndSavesCell: UITableViewCell {
    
    let userData = UserManager.shared
    var viewModel: ProfileViewModel?
    static let reuseIdentifier = "\(PostsAndSavesCell.self)"
    weak var delegate: PostsAndSavesCellDelegate?
    
    var images: [UIImage] = [UIImage(named: "IMG_0752")!, UIImage(named: "IMG_5333")!, UIImage(named: "IMG_9669")! , UIImage(named: "IMG_6462")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_5333")!, UIImage(named: "IMG_6462")!, UIImage(named: "IMG_5333")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_0752")!]
    
    lazy var postsCollectionView: UICollectionView = {
        let layout = LobbyLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(hex: "#F9F4E8")
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private func setUpUI() {
        contentView.addSubview(postsCollectionView)
        contentView.backgroundColor = UIColor(hex: "#F9F4E8")
        
        NSLayoutConstraint.activate([
            postsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postsCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            postsCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            postsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = .white
        
        postsCollectionView.dataSource = self
        postsCollectionView.delegate = self
        postsCollectionView.register(LobbyPostCell.self, forCellWithReuseIdentifier: LobbyPostCell.reuseIdentifier)
        
        setUpUI()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
//        self.contentView.frame = self.bounds
//        self.contentView.layoutIfNeeded()
//        return postsCollectionView.contentSize
//    }
}

extension PostsAndSavesCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.posts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LobbyPostCell.reuseIdentifier, for: indexPath) as? LobbyPostCell else {
            print("Having trouble creating cell")
            return UICollectionViewCell()
        }
        
        if let viewModel = viewModel {
            if indexPath.item < viewModel.posts.count {
                let post = viewModel.posts[indexPath.item]
                let url = URL(string: post.imageUrl)
                cell.imageView.kf.setImage(with: url)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel = viewModel {
            delegate?.presentDetailPage(index: indexPath.row)
        }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.contentView.frame = self.bounds
        self.contentView.layoutIfNeeded()
        // delegate?.reloadTableView()
        return postsCollectionView.contentSize
    }
}

// MARK: - LobbyLayoutDelegate

extension PostsAndSavesCell: LobbyLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        sizeForPhotoAtIndexPath indexPath:IndexPath) -> CGSize {
            
            if let viewModel = viewModel {
                if indexPath.item < viewModel.sizes.count {
                    return viewModel.sizes[indexPath.item]
                } else {
                    return CGSize(width: 300, height: 400)
                }
            } else {
                return CGSize(width: 300, height: 400)
            }
            
            // return images[indexPath.item].size
        }
}

extension PostsAndSavesCell {
    func update(viewModel: ProfileViewModel) {
//        DispatchQueue.main.async {
//            self.postsCollectionView.reloadData()
//            self.postsCollectionView.layoutIfNeeded()
//            self.layoutIfNeeded()
//        }
        self.viewModel = viewModel
        
    }
    
    func updateLayout() {
        // setUpUI()
        DispatchQueue.main.async {
            self.postsCollectionView.collectionViewLayout.invalidateLayout()
            self.postsCollectionView.reloadData()
        }
        
        // postsCollectionView.reloadData()
        // postsCollectionView.layoutIfNeeded()
        // self.layoutIfNeeded()
        
    }
}

protocol PostsAndSavesCellDelegate: AnyObject {
    func presentDetailPage(index: Int)
    
    // func reloadTableView()
}
