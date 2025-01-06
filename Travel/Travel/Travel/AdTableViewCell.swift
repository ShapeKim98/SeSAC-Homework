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
    
    private let backgroundColorList = [
        UIColor(red: 255, green: 0, blue: 0, alpha: 0.5),
        UIColor(red: 0, green: 255, blue: 0, alpha: 0.5),
        UIColor(red: 0, green: 0, blue: 255, alpha: 0.5)
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setTitleLabel()
        
        setAdLabel()
        
        setAdLabelBackgroundView()
        
        setCellBackgroundView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellBackgroundViewReused()
    }
    
    func updateTitleLabel(_ title: String) {
        titleLabel.text = title
    }
    
    private func setTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
    }
    
    private func setAdLabel() {
        adLabel.text = "AD"
        adLabel.font = .systemFont(ofSize: 12)
        adLabel.textAlignment = .center
    }
    
    private func setAdLabelBackgroundView() {
        adLabelBackgroundView.backgroundColor = .white
        adLabelBackgroundView.layer.cornerRadius = 8
        adLabelBackgroundView.clipsToBounds = true
    }
    
    private func setCellBackgroundView() {
        let color = backgroundColorList.randomElement()
        cellBackgroundView.backgroundColor = color
        cellBackgroundView.layer.cornerRadius = 8
        cellBackgroundView.clipsToBounds = true
    }
    
    private func cellBackgroundViewReused() {
        let color = backgroundColorList.randomElement()
        cellBackgroundView.backgroundColor = color
    }
}

extension String {
    static let adCell = "AdTableViewCell"
}
