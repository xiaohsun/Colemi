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
    
    var currentIndex: Int = 0
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: contentView.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        return scrollView
    }()
    
    lazy var postsCollectionView: UICollectionView = {
        let layout = LobbyLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    lazy var savesCollectionView: UICollectionView = {
        let layout = LobbyLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private func setUpUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(postsCollectionView)
        scrollView.addSubview(savesCollectionView)
        contentView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = .white
        
        postsCollectionView.dataSource = self
        postsCollectionView.delegate = self
        postsCollectionView.register(LobbyPostCell.self, forCellWithReuseIdentifier: LobbyPostCell.reuseIdentifier)
        
        savesCollectionView.dataSource = self
        savesCollectionView.delegate = self
        savesCollectionView.register(LobbyPostCell.self, forCellWithReuseIdentifier: LobbyPostCell.reuseIdentifier)
        
        setUpUI()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        postsCollectionView.frame = CGRect(x: CGFloat(0) * scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        savesCollectionView.frame = CGRect(x: CGFloat(1) * scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(2), height: scrollView.bounds.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostsAndSavesCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let viewModel = viewModel else { return 0 }
        
        if collectionView == postsCollectionView {
            return viewModel.posts.count
        } else {
            return viewModel.saves.count
        }
        // viewModel?.posts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LobbyPostCell.reuseIdentifier, for: indexPath) as? LobbyPostCell else {
            print("Having trouble creating cell")
            return UICollectionViewCell()
        }
        
        if let viewModel = viewModel {
            
            if collectionView == postsCollectionView {
                if indexPath.item < viewModel.posts.count {
                    let post = viewModel.posts[indexPath.item]
                    let url = URL(string: post.imageUrl)
                    cell.imageView.kf.setImage(with: url)
                }
                
            } else {
                if indexPath.item < viewModel.saves.count {
                    let post = viewModel.saves[indexPath.item]
                    let url = URL(string: post.imageUrl)
                    cell.imageView.kf.setImage(with: url)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == postsCollectionView {
            delegate?.presentDetailPage(index: indexPath.row, isMyPosts: true)
        } else {
            delegate?.presentDetailPage(index: indexPath.row, isMyPosts: false)
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
                
                if indexPath.item < viewModel.myPostsSizes.count {
                    if collectionView == postsCollectionView {
                        return viewModel.myPostsSizes[indexPath.item]
                    } else {
                        return viewModel.mySavesSizes[indexPath.item]
                    }
                } else {
                    return CGSize(width: 300, height: 400)
                }
                
                // return images[indexPath.item].size
            } else {
                return CGSize(width: 300, height: 400)
            }
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
    
    func updatePostsCollectionViewLayout() {
        // setUpUI()
        DispatchQueue.main.async {
            self.postsCollectionView.collectionViewLayout.invalidateLayout()
            self.postsCollectionView.reloadData()
        }
        
        // postsCollectionView.reloadData()
        // postsCollectionView.layoutIfNeeded()
        // self.layoutIfNeeded()
        
    }
    
    func updateSavesCollectionViewLayout() {
        DispatchQueue.main.async {
            self.savesCollectionView.collectionViewLayout.invalidateLayout()
            self.savesCollectionView.reloadData()
        }
    }
}

protocol PostsAndSavesCellDelegate: AnyObject {
    func presentDetailPage(index: Int, isMyPosts: Bool)
    
    func postsSavesChange(isMyPosts: Bool)
}

extension PostsAndSavesCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        
        if currentIndex != currentPage {
            currentIndex = currentPage
            print("Switched to child view controller at index \(currentIndex)")
            
            if currentIndex == 0 {
                delegate?.postsSavesChange(isMyPosts: true)
            } else {
                delegate?.postsSavesChange(isMyPosts: false)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
    }
}
