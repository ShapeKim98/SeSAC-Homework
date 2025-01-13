//
//  ChatTableViewCell.swift
//  TravelTalk
//
//  Created by 김도형 on 1/11/25.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    @IBOutlet
    private var dateSeparatorLabel: UILabel!
    @IBOutlet
    private var dateSeparatorView: UIView!
    @IBOutlet
    private var dateLabel: UILabel!
    @IBOutlet
    private var messageLabel: UILabel!
    @IBOutlet
    private var bubbleView: UIView!
    @IBOutlet
    private var nameLabel: UILabel!
    @IBOutlet
    private var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureProfileImageView()
        configureBubbleView()
        configureNameLabel()
        configureMessageLabel()
        configureDateLabel()
        configureDateSeparator()
        
        selectionStyle = .none
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = profileImageView.frame.height
        profileImageView.layer.cornerRadius = height / 2
        
        guard !dateSeparatorView.isHidden else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` else { return }
            let separatorHeight = self.dateSeparatorView.frame.height
            self.dateSeparatorView.layer.cornerRadius = separatorHeight / 2
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dateSeparatorView.isHidden = true
        dateSeparatorLabel.isHidden = true
    }
    
    func forRowAt(_ chat: Chat, isSameDay: Bool) {
        profileImageView.image = UIImage(named: chat.user.profileImage)
        nameLabel.text = chat.user.rawValue
        messageLabel.text = chat.message
        
        let rawFormatter: DateFormatter = .cachedFormatter(.chatRaw)
        guard let date = rawFormatter.date(from: chat.date) else {
            return
        }
        let formatter: DateFormatter = .cachedFormatter(.message)
        dateLabel.text = formatter.string(from: date)
        
        if !isSameDay {
            let separatorFormatter: DateFormatter = .cachedFormatter(.separator)
            let separatorText = separatorFormatter.string(from: date)
            dateSeparatorLabel.text = separatorText
            dateSeparatorView.isHidden = false
            dateSeparatorLabel.isHidden = false
        }
    }
}

// MARK: Configure View
private extension ChatTableViewCell {
    func configureProfileImageView() {
        profileImageView.contentMode = .scaleAspectFill
    }
    
    func configureBubbleView() {
        bubbleView.ttBubbleStyle(color: .white)
    }
    
    func configureNameLabel() {
        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.numberOfLines = 0
    }
    
    func configureMessageLabel() {
        messageLabel.ttMessageStyle()
    }
    
    func configureDateLabel() {
        dateLabel.ttDateStyle()
    }
    
    func configureDateSeparator() {
        dateSeparatorView.backgroundColor = .gray
        dateSeparatorLabel.font = .systemFont(ofSize: 12)
        dateSeparatorLabel.textColor = .white
        dateSeparatorView.isHidden = true
        dateSeparatorLabel.isHidden = true
    }
}

extension String {
    static let chatTableCell = "ChatTableViewCell"
}
