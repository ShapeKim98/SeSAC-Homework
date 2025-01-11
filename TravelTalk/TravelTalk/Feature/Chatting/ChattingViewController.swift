//
//  ChattingViewController.swift
//  TravelTalk
//
//  Created by 김도형 on 1/11/25.
//

import UIKit

class ChattingViewController: UIViewController {
    @IBOutlet
    private var messageInputView: UIView!
    @IBOutlet
    private var chatTableView: UITableView!
    @IBOutlet
    private var sendButton: UIButton!
    @IBOutlet
    private var messageTextView: UITextView!
    @IBOutlet
    private var messageTextFieldBackgroundView: UIView!
    
    private var room: ChatRoom = mockChatList[3]
    private var chatList: [Chat] {
        room.chatList.reversed()
    }
    private var message = "" {
        didSet { didSetMessage() }
    }
    private let placeholder = "메세지를 입력하세요"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureChatTableView()
        
        configureSendButton()
        
        configureMessageTextView()
        
        configureMessageTextFieldBackgroundView()
        
        configureMessageInputView()
    }
    
    @IBAction func sendButtonTouchUpInside(_ sender: UIButton) {
        
    }
    
    @IBAction func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: Configure View
private extension ChattingViewController {
    func configureChatTableView() {
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.register(
            UINib(nibName: .chatTableCell, bundle: nil),
            forCellReuseIdentifier: .chatTableCell
        )
        chatTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        chatTableView.separatorStyle = .none
    }
    
    func configureSendButton() {
        sendButton.setTitle("", for: .normal)
        sendButton.setImage(
            UIImage(systemName: "paperplane"),
            for: .normal
        )
        sendButton.tintColor = .secondaryLabel
        sendButton.isEnabled = false
    }
    
    func configureMessageTextView() {
        messageTextView.text = placeholder
        messageTextView.textColor = .placeholderText
        messageTextView.borderStyle = .none
    }
    
    func configureMessageTextFieldBackgroundView() {
        messageTextFieldBackgroundView.backgroundColor = .systemGray5
        messageTextFieldBackgroundView.layer.cornerRadius = 4
        messageTextFieldBackgroundView.clipsToBounds = true
    }
    
    func configureMessageInputView() {
        messageTextView.delegate = self
        messageTextView.isScrollEnabled = false
        messageTextView.backgroundColor = .clear
        view
            .keyboardLayoutGuide
            .topAnchor
            .constraint(
                equalToSystemSpacingBelow: messageInputView.bottomAnchor,
                multiplier: 1.0
            )
            .isActive = true
    }
}

// MARK: Functions
private extension ChattingViewController {
}

// MARK: Data Binding
private extension ChattingViewController {
    func chatCellForRowAt(_ cell: ChatTableViewCell, chat: Chat) {
        cell.forRowAt(chat)
    }
    
    func didSetMessage() {
        sendButton.isEnabled = !message.isEmpty
        let size = messageTextView.sizeThatFits(CGSize(
            width: messageTextView.frame.width,
            height: .infinity
        ))
        for constraint in messageTextView.constraints {
            guard constraint.firstAttribute == .height else {
                continue
            }
            if message.filter(\.isNewline).count <= 3 {
                messageTextView.isScrollEnabled = false
                constraint.constant = size.height
            } else {
                messageTextView.isScrollEnabled = true
                constraint.constant = messageTextView.frame.height
            }
        }
    }
}

extension ChattingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        message = textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.text == placeholder else { return }
        textView.text = nil
        textView.textColor = .label
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.isEmpty else { return }
        textView.text = placeholder
        textView.textColor = .placeholderText
    }
}

extension ChattingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return room.chatList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chatList[indexPath.row]
        let cell = chatTableView.dequeueReusableCell(
            withIdentifier: .chatTableCell,
            for: indexPath
        )
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        guard let chatCell = cell as? ChatTableViewCell else { return cell }
        chatCellForRowAt(chatCell, chat: chat)
        return chatCell
    }
}

extension ChattingViewController: UITableViewDelegate {
    
}
