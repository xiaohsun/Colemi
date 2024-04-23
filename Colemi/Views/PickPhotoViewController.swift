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
    var totalPhotoCount: Int = 0
    var nowPhotoCount: Int = 0
    let batchNum = 50
    // var photoAssets: [PHAsset] = []
    var photoUIImages: [UIImage] = []
    var selectedPicIndex: Int?
    var userData: UserManager?
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>?
    
    lazy var choosePicButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.backgroundColor = ThemeColorProperty.darkColor.getColor()
        button.addTarget(self, action: #selector(choosePicButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        return button
    }()
    
    @objc func choosePicButtonTapped() {
        guard let selectedPicIndex = selectedPicIndex else { return }
        let writePostContentViewController = WritePostContentViewController()
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
        label.textColor = ThemeColorProperty.darkColor.getColor()
        
        return label
    }()
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        
        return view
    }()
    
    private func fetchPhotosFromUser(completion: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                let allPhotosOptions = PHFetchOptions()
                allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                
                let allPhotos = PHAsset.fetchAssets(with: .image, options: allPhotosOptions)
                self.allPhotos = allPhotos
                self.totalPhotoCount = allPhotos.count
                
                completion()
                
            } else {
                print("Failed to get photos from the user")
            }
        }
    }
    
    private func enumeratePHFetchResult(index: Int, completion: @escaping () -> Void) {
        // DispatchQueue.global().async {
            self.allPhotos?.enumerateObjects({ asset, index, _ in
                if index >= self.nowPhotoCount && index <= self.nowPhotoCount + self.batchNum {
                    self.getAssetThumbnail(asset: asset)
                }
            })
        // }
        
        completion()
    }
    
    private func getAssetThumbnail(asset: PHAsset) {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        var image = UIImage()
        manager.requestImage(for: asset, targetSize: CGSize(width: 400, height: 400), contentMode: .aspectFit, options: option, resultHandler: {(result, _) in
            if let result = result {
                image = result
            }
            self.photoUIImages.append(image)
        })
    }
    
    private func updateCollectionView() {
        if totalPhotoCount >= nowPhotoCount + batchNum {
            nowPhotoCount += batchNum
        } else {
            nowPhotoCount = totalPhotoCount
        }
        
        configureDataSource()
        updateSpanshot()
    }
    
    private func setUpUI() {
        view.backgroundColor = ThemeColorProperty.lightColor.getColor()
        
        view.addSubview(missionColorLabel)
        view.addSubview(colorView)
        view.addSubview(photosCollectionView)
        view.addSubview(choosePicButton)
        
        NSLayoutConstraint.activate([
            
            missionColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            missionColorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            
            colorView.topAnchor.constraint(equalTo: missionColorLabel.bottomAnchor, constant: 25),
            colorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            colorView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            photosCollectionView.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 25),
            photosCollectionView.heightAnchor.constraint(equalTo: view.widthAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            choosePicButton.heightAnchor.constraint(equalToConstant: 50),
            choosePicButton.widthAnchor.constraint(equalToConstant: 100),
            choosePicButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110),
            choosePicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        
        photosCollectionView.delegate = self
        
        setUpUI()
        fetchPhotosFromUser {
            self.enumeratePHFetchResult(index: self.nowPhotoCount) {
                DispatchQueue.main.async {
                    self.updateCollectionView()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userData = UserManager.shared
        
        tabBarController?.tabBar.isHidden = false
        
        if let userData = userData {
            colorView.backgroundColor = userData.selectedUIColor
        }
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
            
            // if indexPath.item < self.photoUIImages.count {
                cell.imageView.image = self.photoUIImages[indexPath.item]
            // }
            
            return cell
        }
    }
    
    func updateSpanshot() {
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(Array(0..<nowPhotoCount), toSection: .main)
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPicIndex = indexPath.item
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        let distanceToBottom = contentHeight - offsetY - height
        
        if distanceToBottom < 100 {
            enumeratePHFetchResult(index: nowPhotoCount) {
                DispatchQueue.main.async {
                    self.updateCollectionView()
                }
            }
        }
    }
}
