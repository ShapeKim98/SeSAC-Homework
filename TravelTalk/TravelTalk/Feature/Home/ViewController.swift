//
//  ViewController.swift
//  TravelTalk
//
//  Created by 김도형 on 1/10/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet
    private var roomTableView: UITableView!
    
    private var roomList = mockChatList {
        didSet { filteredRoomList = roomList }
    }
    private var filteredRoomList: [ChatRoom] = [] {
        didSet { roomTableView.reloadData() }
    }
    private var cachedUsers = [Int: Set<String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredRoomList = roomList
        
        cacheUser()
        
        configureChatRoomTableView()
        
        configureSearchController()
    }
}

// MARK: Configure View
private extension ViewController {
    func configureChatRoomTableView() {
        roomTableView.delegate = self
        roomTableView.dataSource = self
        
        roomTableView.register(
            UINib(nibName: .roomTableCell, bundle: nil),
            forCellReuseIdentifier: .roomTableCell
        )
        roomTableView.separatorStyle = .none
    }
    
    func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "친구 이름을 검색해보세요"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
}

// MARK: Data Binding
private extension ViewController {
}

// MARK: Functions
private extension ViewController {
    func cacheUser() {
        for room in roomList {
            var users: Set<String> = []
            for chat in room.chatList {
                guard chat.user != .user else { continue }
                users.insert(chat.user.rawValue.lowercased())
            }
            cachedUsers[room.chatroomId] = users
        }
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        guard !text.isEmpty else {
            filteredRoomList = roomList
            return
        }
        filteredRoomList = roomList.filter { room in
            let isContains = cachedUsers[room.chatroomId]?.contains(where: {
                $0.contains(text)
            })
            return isContains ?? false
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRoomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = roomTableView.dequeueReusableCell(
            withIdentifier: .roomTableCell,
            for: indexPath
        )
        guard let chatRoomCell = cell as? RoomTableViewCell else { return cell }
        let room = filteredRoomList[indexPath.row]
        let count = cachedUsers[room.chatroomId]?.count ?? 0
        chatRoomCell.forRowAt(room, userCount: count + 1)
        return chatRoomCell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(
            identifier: .chattingViewController,
            creator: { [weak self] coder in
                guard let `self` else { return nil }
                let vc = ChattingViewController(
                    coder: coder,
                    room: self.filteredRoomList[indexPath.row]
                )
                vc?.delegate = self
                return vc
            }
        )
        guard let viewController else { return }
        navigationController?.pushViewController(
            viewController,
            animated: true
        )
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension ViewController: ChattingViewControllerDelegate {
    func sendButtonTouchUpInside(_ viewController: ChattingViewController, room: ChatRoom) {
        let row = roomList.firstIndex { $0.chatroomId == room.chatroomId }
        guard let row else { return }
        roomList.remove(at: row)
        roomList.insert(room, at: 0)
    }
}
