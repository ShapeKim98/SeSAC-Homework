//
//  NameLabel.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/23/25.
//

import UIKit

import SnapKit

final class NameLabel: UIView {
    private let nameLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .tgBackground
        layer.cornerRadius = 4
        layer.borderColor = UIColor(resource: .accent).cgColor
        layer.borderWidth = 1
        clipsToBounds = true
        
        nameLabel.textColor = .accent
        nameLabel.font = .systemFont(ofSize: 12, weight: .bold)
        nameLabel.textAlignment = .center
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
    }
    
    func setName(_ name: String) {
        nameLabel.text = name
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
