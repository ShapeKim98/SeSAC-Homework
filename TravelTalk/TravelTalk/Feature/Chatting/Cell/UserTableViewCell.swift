//
//  UserTableViewCell.swift
//  TravelTalk
//
//  Created by 김도형 on 1/11/25.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var bubbleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        configureDateLabel()
        configureMessageLabel()
        configureBubbleView()
        
        selectionStyle = .none
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    func forRowAt(_ chat: Chat) {
        messageLabel.text = chat.message
        
        let rawFormatter: DateFormatter = .cachedFormatter(.chatRaw)
        guard let date = rawFormatter.date(from: chat.date) else {
            return
        }
        let formatter: DateFormatter = .cachedFormatter(.message)
        dateLabel.text = formatter.string(from: date)
    }
}

// MARK: Configure View
private extension UserTableViewCell {
    func configureBubbleView() {
        bubbleView.ttBubbleStyle(color: .systemGray5)
    }
    
    func configureDateLabel() {
        dateLabel.ttDateStyle()
    }
    
    func configureMessageLabel() {
        messageLabel.ttMessageStyle()
    }
}

extension String {
    static let userTableCell = "UserTableViewCell"
}
