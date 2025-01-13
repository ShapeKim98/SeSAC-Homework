//
//  UserTableViewCell.swift
//  TravelTalk
//
//  Created by 김도형 on 1/11/25.
//

import UIKit

class UserTableViewCell: UITableViewCell {
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        configureDateLabel()
        configureMessageLabel()
        configureBubbleView()
        configureDateSeparator()
        
        selectionStyle = .none
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
    
    func configureDateSeparator() {
        dateSeparatorView.backgroundColor = .gray
        dateSeparatorLabel.font = .systemFont(ofSize: 12)
        dateSeparatorLabel.textColor = .white
        dateSeparatorView.isHidden = true
        dateSeparatorLabel.isHidden = true
    }
}

extension String {
    static let userTableCell = "UserTableViewCell"
}
