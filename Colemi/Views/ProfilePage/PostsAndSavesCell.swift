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
    
    var images: [UIImage] = [UIImage(named: "IMG_0752")!, UIImage(named: "IMG_5333")!, UIImage(named: "IMG_9669")! , UIImage(named: "IMG_6462")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_5333")!, UIImage(named: "IMG_6462")!, UIImage(named: "IMG_5333")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_0752")!]
    
    lazy var postsCollectionView: UICollectionView = {
        let layout = LobbyLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(hex: "#F9F4E8")
        
        return collectionView
    }()
    
    private func setUpUI() {
        contentView.addSubview(postsCollectionView)
        contentView.backgroundColor = UIColor(hex: "#F9F4E8")
        
        NSLayoutConstraint.activate([
            postsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postsCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
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
}

extension PostsAndSavesCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // images.count
        userData.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LobbyPostCell.reuseIdentifier, for: indexPath) as? LobbyPostCell else {
            print("Having trouble creating cell")
            return UICollectionViewCell()
        }
        
//        let post = viewModel.posts[indexPath.item]
//        let url = URL(string: post.imageUrl)
//        cell.imageView.kf.setImage(with: url)
        // cell.imageView.image = images[indexPath.item]
        if let viewModel = viewModel {
            if indexPath.item < viewModel.images.count {
                cell.imageView.image = viewModel.images[indexPath.item]
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let postDetailViewController = PostDetailViewController()
//        postDetailViewController.contentJSONString = viewModel.contentJSONString[indexPath.item]
//        postDetailViewController.photoImage = viewModel.images[indexPath.item]
//        // navigationController?.pushViewController(postDetailViewController, animated: true)
//        
//        present(postDetailViewController, animated: true)
        print("Hi")
    }
}

// MARK: - LobbyLayoutDelegate

extension PostsAndSavesCell: LobbyLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        sizeForPhotoAtIndexPath indexPath:IndexPath) -> CGSize {
            
            if let viewModel = viewModel {
                if indexPath.item < viewModel.images.count {
                    return viewModel.images[indexPath.item].size
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
        postsCollectionView.reloadData()
        postsCollectionView.layoutIfNeeded()
        self.layoutIfNeeded()
    }
}
