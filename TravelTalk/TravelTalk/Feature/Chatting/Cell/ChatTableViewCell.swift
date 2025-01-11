//
//  ChatTableViewCell.swift
//  TravelTalk
//
//  Created by 김도형 on 1/11/25.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var bubbleView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureProfileImageView()
        configureBubbleView()
        configureNameLabel()
        configureMessageLabel()
        configureDateLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = profileImageView.frame.height
        profileImageView.layer.cornerRadius = height / 2
    }
    
    func forRowAt(_ chat: Chat) {
        profileImageView.image = UIImage(named: chat.user.profileImage)
        nameLabel.text = chat.user.rawValue
        messageLabel.text = chat.message
        
        let rawFormatter: DateFormatter = .cachedFormatter(.chatRaw)
        guard let date = rawFormatter.date(from: chat.date) else { return }
        let formatter: DateFormatter = .cachedFormatter(.message)
        dateLabel.text = formatter.string(from: date)
    }
}

// MARK: Configure View
private extension ChatTableViewCell {
    func configureProfileImageView() {
        profileImageView.contentMode = .scaleAspectFill
    }
    
    func configureBubbleView() {
        bubbleView.layer.borderColor = UIColor.gray.cgColor
        bubbleView.layer.borderWidth = 1
        bubbleView.layer.cornerRadius = 8
        bubbleView.clipsToBounds = true
    }
    
    func configureNameLabel() {
        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.numberOfLines = 0
    }
    
    func configureMessageLabel() {
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
    }
    
    func configureDateLabel() {
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryLabel
    }
}

extension String {
    static let chatTableCell = "ChatTableViewCell"
}
