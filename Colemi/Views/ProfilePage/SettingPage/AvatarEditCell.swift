//
//  AvatarEditCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/3/24.
//

import UIKit
import PhotosUI

class AvatarEditCell: UITableViewCell {
    
    static let reuseIdentifier = "\(AvatarEditCell.self)"
    weak var delegate: AvatarEditCellDelegate?
//    var imageData: Data?
//    var selectedImage: UIImage?
//    var selectedImageSize: CGSize??
    let viewModel = SettingViewModel()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarGetTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = ThemeColorProperty.lightColor.getColor()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = ThemeColorProperty.lightColor.getColor().cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    @objc private func avatarGetTapped(_ sender: UITapGestureRecognizer) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        delegate?.presentPHPicker(picker)
        // present(picker, animated: true)
    }
    
    lazy var plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarGetTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        imageView.image = .plusIcon
        return imageView
    }()
    
    private func setUpUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(plusImageView)
        
        contentView.backgroundColor = ThemeColorProperty.darkColor.getColor()
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            plusImageView.widthAnchor.constraint(equalToConstant: 20),
            plusImageView.heightAnchor.constraint(equalTo: plusImageView.widthAnchor),
            plusImageView.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: -10),
            plusImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -10)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
}

extension AvatarEditCell: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if !results.isEmpty {
            let result = results.first!
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    guard let image = image as? UIImage,
                          let self = self,
                          let imageData = image.jpegData(compressionQuality: 0.6) else {
                        return
                    }
                    
                    let imageSize = image.size
                    viewModel.uploadImgToFirebase(imageData: imageData, imageSize: imageSize)
                    
                    DispatchQueue.main.async {
                        self.avatarImageView.image = image
                    }
                }
            }
        }
    }
}

protocol AvatarEditCellDelegate: AnyObject {
    func presentPHPicker(_ pickerVC: PHPickerViewController)
}
