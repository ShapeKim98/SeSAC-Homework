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
    
    private var room: ChatRoom = mockChatList[4] {
        didSet { didSetRoom() }
    }
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
        let formatter: DateFormatter = .cachedFormatter(.chatRaw)
        let date = formatter.string(from: Date())
        let newChat = Chat(user: .user, date: date, message: message)
        room.chatList.append(newChat)
        message = ""
        messageTextView.text = ""
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
        chatTableView.register(
            UINib(nibName: .userTableCell, bundle: nil),
            forCellReuseIdentifier: .userTableCell
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
        messageTextFieldBackgroundView.backgroundColor = .systemGray6
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

// MARK: Data Binding
private extension ChattingViewController {
    func didSetMessage() {
        sendButton.isEnabled = message.contains(where: \.isLetter)
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
    
    func didSetRoom() {
        chatTableView.insertRows(
            at: [IndexPath(row: 0, section: 0)],
            with: .top
        )
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
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chatList[indexPath.row]
        let cell = chatTableView.dequeueReusableCell(
            withIdentifier: chat.user == .user
            ? .userTableCell
            : .chatTableCell,
            for: indexPath
        )
        if chat.user == .user {
            guard let chatCell = cell as? UserTableViewCell else { return cell }
            chatCell.forRowAt(chat)
        } else {
            guard let chatCell = cell as? ChatTableViewCell else { return cell }
            chatCell.forRowAt(chat)
        }
        return cell
    }
}

extension ChattingViewController: UITableViewDelegate {
    
}
