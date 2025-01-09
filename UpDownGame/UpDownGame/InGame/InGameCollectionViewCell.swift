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
        configureBackgroundView()
    }
    
    override func prepareForReuse() {
        numberBackgroundView.backgroundColor = .white
        numberLabel.textColor = .black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = frame.width
        
        numberBackgroundView.layer.cornerRadius = width / 2
    }
    
    func setNumber(_ number: Int) {
        numberLabel.text = String(number)
    }
    
    func didSelected(_ number: String) {
        guard number == numberLabel.text else { return }
        
        numberBackgroundView.backgroundColor = .black
        numberLabel.textColor = .white
    }
    
    func onSelect() -> Int? {
        guard let text = numberLabel.text else { return nil }
        return Int(text)
    }
}

// MARK: View
private extension InGameCollectionViewCell {
    func configureBackgroundView() {
        numberBackgroundView.backgroundColor = .white
    }
    
    func configureNumberLabel() {
        numberLabel.textColor = .black
        numberLabel.font = .systemFont(ofSize: 14)
    }
}

extension String {
    static let inGameCollectionCell = "InGameCollectionViewCell"
}
