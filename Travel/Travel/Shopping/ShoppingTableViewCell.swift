//
//  ShoppingTableViewCell.swift
//  Travel
//
//  Created by 김도형 on 1/5/25.
//

import UIKit

class ShoppingTableViewCell: UITableViewCell {
    @IBOutlet var boughtButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var cellBackgroundView: UIView!
    
    func setCellBackgroundView() {
        cellBackgroundView.backgroundColor = .systemGray5
        cellBackgroundView.layer.cornerRadius = 8
        cellBackgroundView.clipsToBounds = true
    }
    
    func setTitleLabel(title: String) {
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textAlignment = .left
    }
    
    func setBoughtButton(isBought: Bool, row: Int, target: Any?, action: Selector) {
        let imageName = isBought ? "checkmark.square.fill" : "checkmark.square"
        boughtButton.setImage(
            UIImage(systemName: imageName),
            for: .normal
        )
        setButton(boughtButton, tag: row, target: target, action: action)
    }
    
    func setFavoriteButton(isFavorite: Bool, row: Int, target: Any?, action: Selector) {
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(
            UIImage(systemName: imageName),
            for: .normal
        )
        setButton(favoriteButton, tag: row, target: target, action: action)
    }
    
    func setButton(_ button: UIButton, tag: Int, target: Any?, action: Selector) {
        button.setTitle("", for: .normal)
        button.tintColor = .black
        button.tag = tag
        button.addTarget(target, action: action, for: .touchUpInside)
    }
}

extension String {
    static let shoppingCell = "ShoppingTableViewCell"
}
