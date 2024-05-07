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
        button.titleLabel?.font = UIFont(name: FontProperty.GenSenRoundedTW_M.rawValue, size: 14)
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
        
        for chatRoom in viewModel.userData.chatRooms where chatRoom.receiverID == viewModel.otherUserData?.id {
            isChattedBefore = true
            chatRoomID = chatRoom.id
            break
        }
        
        if !isChattedBefore {
            viewModel.createDetailedChatRoom()
            delegate?.pushToChatRoom(chatRoomID: viewModel.chatRoomID)
        } else {
            delegate?.pushToChatRoom(chatRoomID: chatRoomID)
        }
        
        print("私訊！")
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
