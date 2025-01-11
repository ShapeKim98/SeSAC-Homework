//
//  ViewController.swift
//  TravelTalk
//
//  Created by 김도형 on 1/10/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet
    private var chatTableView: UITableView!
    
    private var chatList = mockList {
        didSet { chatTableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureChatRoomTableView()
        
        configureSearchController()
    }
}

// MARK: Configure View
private extension ViewController {
    func configureChatRoomTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        chatTableView.register(
            UINib(nibName: .chatTableCell, bundle: nil),
            forCellReuseIdentifier: .chatTableCell
        )
        chatTableView.separatorStyle = .none
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
    func injectDataAtChatCell(_ cell: ChatTableViewCell, row: Int) {
        let chat = chatList[row]
        cell.injectCellData(chat)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        guard !text.isEmpty else {
            chatList = mockList
            return
        }
        chatList = mockList.filter { chat in
            chat.user.rawValue.lowercased().contains(text)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(
            withIdentifier: .chatTableCell,
            for: indexPath
        )
        guard let chatRoomCell = cell as? ChatTableViewCell else { return cell }
        injectDataAtChatCell(chatRoomCell, row: indexPath.row)
        return chatRoomCell
    }
}

extension ViewController: UITableViewDelegate {
    
}
