//
//  ShoppingTableViewController.swift
//  Travel
//
//  Created by 김도형 on 1/5/25.
//

import UIKit

class ShoppingTableViewController: UITableViewController {
    @IBOutlet var headerViewBackground: UIView!
    @IBOutlet var shoppingTextField: UITextField!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var tableHeaderView: UIView!
     
    private var shoppingList: [Shopping] = Shopping.defaultList

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableHeaderView()
        
        setShoppingTextField()
        
        setAddButton()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: .shoppingCell,
            for: indexPath
        )
        guard let shoppingCell = cell as? ShoppingTableViewCell else {
            return cell
        }
        
        let shopping = shoppingList[indexPath.row]
        
        shoppingCell.setCellBackgroundView()
        shoppingCell.setTitleLabel(title: shopping.title)
        shoppingCell.setBoughtButton(
            isBought: shopping.isBought,
            row: indexPath.row,
            target: self,
            action: #selector(boughtButtonTouchUpInside)
        )
        shoppingCell.setFavoriteButton(
            isFavorite: shopping.isFavorite,
            row: indexPath.row,
            target: self,
            action: #selector(favoriteButtonTouchUpInside)
        )
        return shoppingCell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "삭제"
        ) { [weak self] _, _, completion in
            guard let `self` else { return }
            self.shoppingList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [
            deleteAction
        ])
        return configuration
    }
    
    private func setTableHeaderView() {
        headerViewBackground.backgroundColor = .systemGray5
        headerViewBackground.layer.cornerRadius = 8
        headerViewBackground.clipsToBounds = true
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
    
    private func updateCell(row: Int) {
        tableView.reloadRows(
            at: [.init(row: row, section: 0)],
            with: .automatic
        )
    }
    
    @objc
    private func boughtButtonTouchUpInside(_ sender: UIButton) {
        shoppingList[sender.tag].isBought.toggle()
        updateCell(row: sender.tag)
    }
    
    @objc
    private func favoriteButtonTouchUpInside(_ sender: UIButton) {
        shoppingList[sender.tag].isFavorite.toggle()
        updateCell(row: sender.tag)
    }

    @IBAction func addButtonTouchUpInside(_ sender: UIButton) {
        guard
            let text = shoppingTextField.text,
            !text.isEmpty
        else { return }
        shoppingList.append(Shopping(title: text))
        tableView.insertRows(
            at: [.init(row: shoppingList.count - 1, section: 0)],
            with: .automatic
        )
        shoppingTextField.text = ""
        view.endEditing(true)
    }
}
