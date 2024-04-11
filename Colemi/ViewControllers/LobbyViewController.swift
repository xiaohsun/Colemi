//
//  ViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/10/24.
//

import UIKit

class LobbyViewController: UIViewController {
    
    var images: [UIImage] = [UIImage(named: "IMG_0752")!, UIImage(named: "IMG_5333")!, UIImage(named: "IMG_9669")! , UIImage(named: "IMG_6462")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_5333")!, UIImage(named: "IMG_6462")!, UIImage(named: "IMG_5333")!, UIImage(named: "IMG_0752")!, UIImage(named: "IMG_0752")!]
    
    lazy var postButton: UIButton = {
        let button = UIButton()
        // button.setTitleColor(<#T##color: UIColor?##UIColor?#>, for: <#T##UIControl.State#>)
        button.setTitle("Post", for: .normal)
        // button.titleLabel?.font = UIFont(name: <#T##String#>, size: <#T##CGFloat#>)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(postBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func postBtnTapped() {
        print("Hi")
    }
    
    lazy var postsCollectionView: UICollectionView = {
        let layout = LobbyLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        postsCollectionView.register(LobbyPostCell.self, forCellWithReuseIdentifier: LobbyPostCell.reuseIdentifier)
        
        view.addSubview(postsCollectionView)
        view.addSubview(postButton)
        
        NSLayoutConstraint.activate([
            postsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            postsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            postsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            postButton.heightAnchor.constraint(equalToConstant: 50),
            postButton.widthAnchor.constraint(equalToConstant: 100),
            postButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension LobbyViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LobbyPostCell.reuseIdentifier, for: indexPath) as? LobbyPostCell else {
            print("Having trouble creating cell")
            return UICollectionViewCell()
        }
        
        cell.imageView.image = images[indexPath.item]
        return cell
    }
}

extension LobbyViewController: LobbyLayoutDelegate {
  func collectionView(
      _ collectionView: UICollectionView,
      sizeForPhotoAtIndexPath indexPath:IndexPath) -> CGSize {
          return images[indexPath.item].size
  }
}
