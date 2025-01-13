//
//  ChattingViewController.swift
//  TravelTalk
//
//  Created by 김도형 on 1/11/25.
//

import UIKit

protocol ChattingViewControllerDelegate: AnyObject {
    func sendButtonTouchUpInside(_ viewController: ChattingViewController, room: ChatRoom)
}

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
    
    private var room: ChatRoom
    private var chatList: [Chat] {
        didSet { didChatList() }
    }
    private var message = "" {
        didSet { didSetMessage() }
    }
    private let placeholder = "메세지를 입력하세요"
    
    weak var delegate: (any ChattingViewControllerDelegate)?
    
    init?(coder: NSCoder, room: ChatRoom) {
        self.room = room
        self.chatList = room.chatList.reversed()
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
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
        chatList.insert(newChat, at: 0)
        room.chatList.append(newChat)
        delegate?.sendButtonTouchUpInside(self, room: room)
        message = ""
        messageTextView.text = ""
    }
    
    @IBAction func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: Configure View
private extension ChattingViewController {
    func configureNavigationBar() {
        navigationItem.title = room.chatroomName
        navigationController?.navigationBar.topItem?.title = ""
    }
    
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
    
    func didChatList() {
        chatTableView.insertRows(
            at: [IndexPath(row: 0, section: 0)],
            with: .top
        )
    }
}

// MARK: Functions
private extension ChattingViewController {
    func isSameDay(from: String, to: String) -> Bool {
        let formatter: DateFormatter = .cachedFormatter(.chatRaw)
        guard
            let fromDate = formatter.date(from: from),
            let toDate = formatter.date(from: to)
        else { return false }
        let calendar = Calendar.current
       
        return calendar.isDate(fromDate, inSameDayAs: toDate)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chatList[indexPath.row]
        let cell = chatTableView.dequeueReusableCell(
            withIdentifier: chat.user == .user
            ? .userTableCell
            : .chatTableCell,
            for: indexPath
        )
        var isSameDay: Bool = true
        if indexPath.row < chatList.count - 1 {
            let beforeChat = chatList[indexPath.row + 1]
            isSameDay = self.isSameDay(from: chat.date, to: beforeChat.date)
        }
        if chat.user == .user {
            guard let chatCell = cell as? UserTableViewCell else { return cell }
            chatCell.forRowAt(chat, isSameDay: isSameDay)
        } else {
            guard let chatCell = cell as? ChatTableViewCell else { return cell }
            chatCell.forRowAt(chat, isSameDay: isSameDay)
        }
        return cell
    }
}

extension ChattingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
}

extension String {
    static let chattingViewController = "ChattingViewController"
}
