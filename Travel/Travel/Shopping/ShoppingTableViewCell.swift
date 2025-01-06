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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCellBackgroundView()
        
        setTitleLabel()
        
        setBoughtButton()
        
        setFavoriteButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        boughtButtonReused()
        favoriteButtonReused()
    }
    
    func updateTitleLabel(title: String) {
        titleLabel.text = title
    }
    
    func updateBoughtButton(isBought: Bool, row: Int, target: Any?, action: Selector) {
        if isBought {
            boughtButton.setImage(
                UIImage(systemName: "checkmark.square.fill"),
                for: .normal
            )
        }
        boughtButton.tag = row
        boughtButton.addTarget(
            target,
            action: action,
            for: .touchUpInside
        )
    }
    
    func updateFavoriteButton(isFavorite: Bool, row: Int, target: Any?, action: Selector) {
        if isFavorite {
            favoriteButton.setImage(
                UIImage(systemName: "star.fill"),
                for: .normal
            )
        }
        favoriteButton.tag = row
        favoriteButton.addTarget(
            target,
            action: action,
            for: .touchUpInside
        )
    }
    
    private func setCellBackgroundView() {
        cellBackgroundView.backgroundColor = .systemGray5
        cellBackgroundView.layer.cornerRadius = 8
        cellBackgroundView.clipsToBounds = true
    }
    
    private func setTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textAlignment = .left
    }
    
    private func setBoughtButton() {
        boughtButton.setImage(
            UIImage(systemName: "checkmark.square"),
            for: .normal
        )
        setButton(boughtButton)
    }
    
    private func setFavoriteButton() {
        favoriteButton.setImage(
            UIImage(systemName: "star"),
            for: .normal
        )
        setButton(favoriteButton)
    }
    
    private func setButton(_ button: UIButton) {
        button.setTitle("", for: .normal)
        button.tintColor = .black
    }
    
    private func boughtButtonReused() {
        boughtButton.setImage(
            UIImage(systemName: "checkmark.square"),
            for: .normal
        )
    }
    
    private func favoriteButtonReused() {
        favoriteButton.setImage(
            UIImage(systemName: "star"),
            for: .normal
        )
    }
}

extension String {
    static let shoppingCell = "ShoppingTableViewCell"
}
