//
//  AdTableViewCell.swift
//  Travel
//
//  Created by 김도형 on 1/5/25.
//

import UIKit

class AdTableViewCell: UITableViewCell {
    @IBOutlet var adLabel: UILabel!
    @IBOutlet var adLabelBackgroundView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var cellBackgroundView: UIView!
    
    private let backgrouncColorList = [
        UIColor(red: 255, green: 0, blue: 0, alpha: 0.5),
        UIColor(red: 0, green: 255, blue: 0, alpha: 0.5),
        UIColor(red: 0, green: 0, blue: 255, alpha: 0.5)
    ]
    
    func setTitleLabel(title: String) {
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
    }
    
    func setAdLabel() {
        adLabel.text = "AD"
        adLabel.font = .systemFont(ofSize: 12)
        adLabel.textAlignment = .center
    }
    
    func setAdLabelBackgroundView() {
        adLabelBackgroundView.backgroundColor = .white
        adLabelBackgroundView.layer.cornerRadius = 8
        adLabelBackgroundView.clipsToBounds = true
    }
    
    func setCellBackgroundView() {
        let color = backgrouncColorList.randomElement()
        cellBackgroundView.backgroundColor = color
        cellBackgroundView.layer.cornerRadius = 8
        cellBackgroundView.clipsToBounds = true
    }
}

extension String {
    static let adCell = "AdTableViewCell"
}
