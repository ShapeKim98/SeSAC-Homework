//
//  ChatRoomTableViewCell.swift
//  TravelTalk
//
//  Created by 김도형 on 1/10/25.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
    @IBOutlet var userCountLabel: UILabel!
    @IBOutlet var chat4ImageViewList: [UIImageView]!
    @IBOutlet var chat3ImageViewList: [UIImageView]!
    @IBOutlet var chat2ImageViewList: [UIImageView]!
    @IBOutlet var chatImageView: [UIImageView]!
    @IBOutlet var chatDateLabel: UILabel!
    @IBOutlet var chatMessageLabel: UILabel!
    @IBOutlet var chatNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureChatRoomNameLabel()
        configureChatDateLabel()
        configureChatMessageLabel()
        configureChatRoomImageView()
        configureUserCountLabel()
    }
    
    override func prepareForReuse() {
        chatImageView.forEach { $0.isHidden = true }
        chat2ImageViewList.forEach { $0.isHidden = true }
        chat3ImageViewList.forEach { $0.isHidden = true }
        chat4ImageViewList.forEach { $0.isHidden = true }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circleImageView(chatImageView)
        circleImageView(chat2ImageViewList)
        circleImageView(chat3ImageViewList)
        circleImageView(chat4ImageViewList)
    }
    
    func forRowAt(_ room: ChatRoom, userCount: Int) {
        let uiImages = room.chatroomImage.compactMap { UIImage(named: $0) }
        if userCount > 1 {
            userCountLabel.text = "\(userCount)"
        } else {
            userCountLabel.text = ""
        }
        
        switch uiImages.count {
        case 1: updateImages(chatImageView, images: uiImages)
        case 2: updateImages(chat2ImageViewList, images: uiImages)
        case 3: updateImages(chat3ImageViewList, images: uiImages)
        case 4...: updateImages(chat4ImageViewList, images: uiImages)
        default: break
        }
        
        chatNameLabel.text = room.chatroomName
        
        let chatList = room.chatList.sorted { lhs, rhs in
            let formatter: DateFormatter = .cachedFormatter(.chatRaw)
            let lhsDate = formatter.date(from: lhs.date) ?? .now
            let rhsDate = formatter.date(from: rhs.date) ?? .now
            return lhsDate < rhsDate
        }
        
        chatMessageLabel.text = chatList.last?.message
        
        guard let lastChat = chatList.last else { return }
        let rawFormatter: DateFormatter = .cachedFormatter(.chatRaw)
        guard let date = rawFormatter.date(from: lastChat.date) else { return }
        let formatter: DateFormatter = .cachedFormatter(.chat)
        let dateString = formatter.string(from: date)
        
        chatDateLabel.text = dateString
    }
    
    func updateImages(_ imageViewList: [UIImageView], images: [UIImage]) {
        for (index, imageView) in imageViewList.enumerated() {
            imageView.isHidden = false
            imageView.image = images[index]
        }
    }
    
    func circleImageView(_ imageViewList: [UIImageView]) {
        for imageView in imageViewList {
            let height = imageView.frame.height
            imageView.layer.cornerRadius = height / 2
        }
    }
}

// MARK: Configure View
private extension RoomTableViewCell {
    func configureChatRoomImageView() {
        chatImageView.forEach { $0.contentMode = .scaleAspectFill }
        chat2ImageViewList.forEach { $0.contentMode = .scaleAspectFill }
        chat3ImageViewList.forEach { $0.contentMode = .scaleAspectFill }
        chat4ImageViewList.forEach { $0.contentMode = .scaleAspectFill }
    }
    
    func configureChatRoomNameLabel() {
        chatNameLabel.font = .boldSystemFont(ofSize: 16)
    }
    
    func configureChatMessageLabel() {
        chatMessageLabel.font = .systemFont(ofSize: 14)
        chatMessageLabel.textColor = .secondaryLabel
    }
    
    func configureChatDateLabel() {
        chatDateLabel.ttDateStyle()
    }
    
    func configureUserCountLabel() {
        userCountLabel.textColor = .secondaryLabel
        userCountLabel.font = .boldSystemFont(ofSize: 14)
    }
}

extension String {
    static let roomTableCell = "RoomTableViewCell"
}
