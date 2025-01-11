//
//  ChatRoomTableViewCell.swift
//  TravelTalk
//
//  Created by 김도형 on 1/10/25.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    @IBOutlet var chatDateLabel: UILabel!
    @IBOutlet var chatMessageLabel: UILabel!
    @IBOutlet var chatNameLabel: UILabel!
    @IBOutlet var chatImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureChatRoomNameLabel()
        configureChatDateLabel()
        configureChatMessageLabel()
        configureChatRoomImageView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = chatImageView.frame.height
        chatImageView.layer.cornerRadius = height / 2
    }
    
    func injectCellData(_ chat: Chat) {
        chatImageView.image = UIImage(named: chat.user.profileImage)
        
        chatNameLabel.text = chat.user.rawValue
        
        chatMessageLabel.text = chat.message
        
        let rawFormatter: DateFormatter = .cachedFormatter(.chatRaw)
        guard let date = rawFormatter.date(from: chat.date) else { return }
        let formatter: DateFormatter = .cachedFormatter(.chat)
        let dateString = formatter.string(from: date)
        
        chatDateLabel.text = dateString
    }
}

// MARK: Configure View
private extension ChatTableViewCell {
    func configureChatRoomImageView() {
        chatImageView.contentMode = .scaleAspectFill
    }
    
    func configureChatRoomNameLabel() {
        chatNameLabel.font = .boldSystemFont(ofSize: 16)
    }
    
    func configureChatMessageLabel() {
        chatMessageLabel.font = .systemFont(ofSize: 14)
        chatMessageLabel.textColor = .secondaryLabel
    }
    
    func configureChatDateLabel() {
        chatDateLabel.font = .systemFont(ofSize: 12)
        chatDateLabel.textColor = .secondaryLabel
    }
}

extension String {
    static let chatTableCell = "ChatTableViewCell"
}
