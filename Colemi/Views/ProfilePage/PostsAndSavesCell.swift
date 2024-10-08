//
//  PostsAndSavesCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/18/24.
//

import UIKit
import Kingfisher

class PostsAndSavesCell: UITableViewCell {
    
    let userData = UserManager.shared
    var viewModel: ProfileViewModel?
    static let reuseIdentifier = "\(PostsAndSavesCell.self)"
    weak var delegate: PostsAndSavesCellDelegate?
    
    var postsCollectionViewContentSizeHeight: CGFloat = 0
    var savesCollectionViewContentSizeHeight: CGFloat = 0
    var scrollViewHeight: NSLayoutConstraint?
    
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
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    lazy var savesCollectionView: UICollectionView = {
        let layout = LobbyLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    private func setupUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(postsCollectionView)
        scrollView.addSubview(savesCollectionView)
        contentView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        
        scrollViewHeight = scrollView.heightAnchor.constraint(equalToConstant: 2000)
        scrollViewHeight?.isActive = true
        
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
        
        setupUI()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        postsCollectionView.frame = CGRect(x: CGFloat(0) * scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        savesCollectionView.frame = CGRect(x: CGFloat(1) * scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(2), height: scrollView.bounds.height)
        
        layoutIfNeeded()
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
                    cell.imageView.kf.setImage(with: url, options: [
                        .transition(ImageTransition.fade(0.3)),
                        .forceTransition,
                        .keepCurrentImageWhileLoading
                  ])
                }
                
            } else {
                if indexPath.item < viewModel.saves.count {
                    let post = viewModel.saves[indexPath.item]
                    let url = URL(string: post.imageUrl)
                    cell.imageView.kf.setImage(with: url, options: [
                        .transition(ImageTransition.fade(0.3)),
                        .forceTransition,
                        .keepCurrentImageWhileLoading
                  ])
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? LobbyPostCell else { return }
        
        if collectionView == postsCollectionView {
            delegate?.presentDetailPage(index: indexPath.row, isMyPosts: true, selectedCell: selectedCell, collectionView: postsCollectionView, selectedImageView: selectedCell.imageView)
        } else {
            delegate?.presentDetailPage(index: indexPath.row, isMyPosts: false, selectedCell: selectedCell, collectionView: savesCollectionView, selectedImageView: selectedCell.imageView)
        }
    }
}

// MARK: - LobbyLayoutDelegate

extension PostsAndSavesCell: LobbyLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        sizeForPhotoAtIndexPath indexPath:IndexPath) -> CGSize {
            
            guard let viewModel = viewModel else { return CGSize(width: 300, height: 400) }
            
            if collectionView == postsCollectionView {
                if indexPath.item < viewModel.myPostsSizes.count {
                    return viewModel.myPostsSizes[indexPath.item]
                } else {
                    return CGSize(width: 300, height: 400)
                }
            } else {
                if indexPath.item < viewModel.mySavesSizes.count {
                    return viewModel.mySavesSizes[indexPath.item]
                } else {
                    return CGSize(width: 300, height: 400)
                }
            }
            
            
            
            //                if indexPath.item < viewModel.myPostsSizes.count {
            //                    if indexPath.item != viewModel.myPostsSizes.count - 1 {
            //                        if collectionView == postsCollectionView {
            //                            return viewModel.myPostsSizes[indexPath.item]
            //                        } else {
            //                            return viewModel.mySavesSizes[indexPath.item]
            //                        }
            //                    } else {
            //                        if collectionView == postsCollectionView {
            //                            return viewModel.myPostsSizes[indexPath.item]
            //                        } else {
            //                            return viewModel.mySavesSizes[indexPath.item]
            //                        }
            //                    }
            //
            //                } else {
            //                    return CGSize(width: 300, height: 400)
            //                }
            //
            //            } else {
            //                return CGSize(width: 300, height: 400)
            //            }
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
            self.postsCollectionView.layoutIfNeeded()
            self.postsCollectionViewContentSizeHeight = self.postsCollectionView.contentSize.height
        }
        
        // postsCollectionView.reloadData()
        // postsCollectionView.layoutIfNeeded()
        // self.layoutIfNeeded()
        
    }
    
    func updateSavesCollectionViewLayout() {
        DispatchQueue.main.async {
            self.savesCollectionView.collectionViewLayout.invalidateLayout()
            self.savesCollectionView.reloadData()
            self.savesCollectionView.layoutIfNeeded()
            self.savesCollectionViewContentSizeHeight = self.savesCollectionView.contentSize.height
            
            if self.savesCollectionViewContentSizeHeight > self.postsCollectionViewContentSizeHeight {
                self.scrollViewHeight?.constant = self.savesCollectionViewContentSizeHeight + 20
            } else {
                self.scrollViewHeight?.constant = self.postsCollectionViewContentSizeHeight + 20
            }
            
            self.layoutIfNeeded()
            self.delegate?.reloadTableView()
        }
    }
}

protocol PostsAndSavesCellDelegate: AnyObject {
    func presentDetailPage(index: Int, isMyPosts: Bool, selectedCell: LobbyPostCell, collectionView: UICollectionView, selectedImageView: UIImageView)
    
    func postsSavesChange(isMyPosts: Bool)
    
    func reloadTableView()
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
