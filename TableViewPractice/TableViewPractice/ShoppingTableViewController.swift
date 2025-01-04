//
//  ShoppingTableViewController.swift
//  TableViewPractice
//
//  Created by 김도형 on 1/2/25.
//

import UIKit

class ShoppingTableViewController: UITableViewController {
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var shoppingTextField: UITextField!
    
    private var shoppingList: [String] = [
        "그립톡 구매하기",
        "사이다 구매",
        "아이패드 케이스 최저가 알아보기",
        "양말"
    ] {
        didSet { tableView.reloadData() }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableHeaderView()
        
        setShoppingTextField()
        
        setAddButton()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: .tableCell(.shopping)
        )!
        
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(systemName: "checkmark.square")
        content.text = shoppingList[indexPath.row]
        content.imageProperties.tintColor = .black
        content.imageProperties.maximumSize = CGSize(width: 20, height: 20)
        content.textProperties.font = .systemFont(ofSize: 14)
        
        cell.contentConfiguration = content
        
        // ???: UITableViewCell을 직접 상속받은 객체로 커스텀해서 cell사이의 간격을 조절하는 방식이 많이 보이는데, 올바른 방식인지 궁금합니다! 그냥 알아본거 가져다 쓰기에는 어떻게 돌아가는지, 이 방식밖에는 없는지 잘 모르겠어서 질문을 남깁니다!
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemGray5
        backgroundView.layer.cornerRadius = 4
        cell.backgroundView = backgroundView
        return cell
    }
    
    private func setTableHeaderView() {
        tableHeaderView.backgroundColor = .systemGray5
        tableHeaderView.layer.cornerRadius = 8
        tableHeaderView.clipsToBounds = true
    }
    
    private func setShoppingTextField() {
        shoppingTextField.borderStyle = .none
        shoppingTextField.placeholder = "무엇을 구매하실 건가요?"
    }
    
    private func setAddButton() {
        addButton.setTitle("추가", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.backgroundColor = .systemGray4
        addButton.layer.cornerRadius = 8
        addButton.clipsToBounds = true
        addButton.configuration?.buttonSize = .mini
    }
    
    @IBAction func addButtonTouchUpInside(_ sender: UIButton) {
        guard
            let text = shoppingTextField.text,
            !text.isEmpty
        else { return }
        shoppingList.append(text)
        shoppingTextField.text = ""
        view.endEditing(true)
    }
}

extension ShoppingTableViewController {
    enum Cell: String {
        case shopping = "ShoppingCell"
    }
}

extension String {
    static func tableCell(_ cell: ShoppingTableViewController.Cell) -> String {
        return cell.rawValue
    }
}
