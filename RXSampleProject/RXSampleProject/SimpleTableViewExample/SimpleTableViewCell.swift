//
//  SimpleTableViewCell.swift
//  RXSampleProject
//
//  Created by 김도형 on 2/18/25.
//

import UIKit

import SnapKit

final class SimpleTableViewCell: UITableViewCell {
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func forRowAt(_ text: String) {
        label.text = text
    }
}
