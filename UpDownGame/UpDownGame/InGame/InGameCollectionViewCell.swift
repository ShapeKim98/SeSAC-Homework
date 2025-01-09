//
//  InGameCollectionViewCell.swift
//  UpDownGame
//
//  Created by 김도형 on 1/9/25.
//

import UIKit

class InGameCollectionViewCell: UICollectionViewCell {
    @IBOutlet
    private var numberLabel: UILabel!
    @IBOutlet
    private var numberBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        configureNumberLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureBackgroundView()
    }
}

// MARK: View
private extension InGameCollectionViewCell {
    func configureBackgroundView() {
        numberBackgroundView.backgroundColor = .white
        let width = numberBackgroundView.frame.width
        
        numberBackgroundView.layer.cornerRadius = width / 2
    }
    
    func configureNumberLabel() {
        numberLabel.textColor = .black
        numberLabel.font = .systemFont(ofSize: 12)
    }
}

extension String {
    static let inGameCollectionCell = "InGameCollectionViewCell"
}
