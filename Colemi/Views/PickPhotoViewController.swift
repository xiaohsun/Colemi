//
//  PickPhotoViewController.swift
//  Colemi
//
//  Created by 徐柏勳 on 4/11/24.
//

import UIKit
import Photos

class PickPhotoViewController: UIViewController {
    
    var allPhotos: PHFetchResult<PHAsset>?
    var photoAssets: [PHAsset] = []
    var photoUIImages: [UIImage] = []
    var selectedPicIndex: Int?
    let userManager = UserManager.shared
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>?
    
    lazy var writePostContentViewController: WritePostContentViewController = {
        let viewController = WritePostContentViewController()
        return viewController
    }()
    
    lazy var choosePicButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(choosePicButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func choosePicButtonTapped() {
        guard let selectedPicIndex = selectedPicIndex else { return }
        writePostContentViewController.selectedImage = photoUIImages[selectedPicIndex]
        navigationController?.pushViewController(writePostContentViewController, animated: true)
    }
    
    lazy var photosCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: configureLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    lazy var missionColorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "任務顏色"
        
        return label
    }()
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.backgroundColor = userManager.selectedUIColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private func getAssetThumbnail(assets: [PHAsset]) {
        for asset in assets {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var image = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: asset, targetSize: CGSize(width: 400, height: 400), contentMode: .aspectFit, options: option, resultHandler: {(result, _) in
                if let result = result {
                    image = result
                }
                    self.photoUIImages.append(image)
            })
        }
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        
        view.addSubview(missionColorLabel)
        view.addSubview(colorView)
        view.addSubview(photosCollectionView)
        view.addSubview(choosePicButton)
        
        NSLayoutConstraint.activate([
            
            missionColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            missionColorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            colorView.topAnchor.constraint(equalTo: missionColorLabel.bottomAnchor, constant: 50),
            colorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            colorView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            photosCollectionView.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 50),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            choosePicButton.heightAnchor.constraint(equalToConstant: 50),
            choosePicButton.widthAnchor.constraint(equalToConstant: 100),
            choosePicButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            choosePicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func fetchPhotosFromUser() {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                let allPhotosOptions = PHFetchOptions()
                allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                self.allPhotos = PHAsset.fetchAssets(with: .image, options: allPhotosOptions)
                
                DispatchQueue.main.async {
                    self.allPhotos?.enumerateObjects { (asset, index, _) in
                        if index <= 5 {
                            self.photoAssets.append(asset)
                        }
                    }
                    self.getAssetThumbnail(assets: self.photoAssets.reversed())
                    self.configureDataSource()
                    self.updateSpanshot()
                }
            } else {
                print("Failed to get photos from the user")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        
        photosCollectionView.delegate = self
        
        setUpUI()
        fetchPhotosFromUser()
        
        
    }
}

// MARK: - UICollectionViewDelegate

extension PickPhotoViewController: UICollectionViewDelegate {
    
    func configureLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(1/3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        
        let section = NSCollectionLayoutSection(group: group)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        return UICollectionViewCompositionalLayout(section: section, configuration: config)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: photosCollectionView) { (collectionView, indexPath, _: Int) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell else { fatalError("Can't create new cell") }
            
            cell.imageView.image = self.photoUIImages[indexPath.item]
            
            return cell
        }
    }
    
    func updateSpanshot() {
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(Array(0..<self.photoUIImages.count), toSection: .main)
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPicIndex = indexPath.item
    }
}
