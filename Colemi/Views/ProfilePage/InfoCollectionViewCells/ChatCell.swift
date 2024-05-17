//
//  ChatCell.swift
//  Colemi
//
//  Created by 徐柏勳 on 5/3/24.
//

import UIKit

class ChatCell: UICollectionViewCell {
    
    static let reuseIdentifier = "\(ChatCell.self)"
    let viewModel = ChatCellViewModel()
    weak var delegate: ChatCellDelegate?
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = ThemeFontProperty.GenSenRoundedTW_M.getFont(size: 14)
        button.backgroundColor = .white
        button.setTitleColor(ThemeColorProperty.darkColor.getColor(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("私訊", for: .normal)
        button.layer.cornerRadius = RadiusProperty.radiusTen.rawValue
        button.addTarget(self, action: #selector(chatBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func chatBtnTapped(_ sender: UIButton) {
        var isChattedBefore = false
        var chatRoomID = ""
        
        Task { 
            await viewModel.getUserData {
                DispatchQueue.main.async {
                    for chatRoom in self.viewModel.userData.chatRooms where chatRoom.receiverID == self.viewModel.otherUserData?.id {
                        isChattedBefore = true
                        chatRoomID = chatRoom.id
                        break
                    }
                    
                    if !isChattedBefore {
                        self.viewModel.createDetailedChatRoom()
                        self.delegate?.pushToChatRoom(chatRoomID: self.viewModel.chatRoomID)
                    } else {
                        self.delegate?.pushToChatRoom(chatRoomID: chatRoomID)
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ChatCell {
    func update() {
    }
}

protocol ChatCellDelegate: AnyObject {
    func pushToChatRoom(chatRoomID: String)
}
