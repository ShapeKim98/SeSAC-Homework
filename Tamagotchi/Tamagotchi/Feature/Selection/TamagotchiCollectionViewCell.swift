//
//  TamagotchCollectionViewCell.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/23/25.
//

import UIKit

import SnapKit

class TamagotchiCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let nameLabel = NameLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func forItemAt(_ tamagotchi: Tamagotchi) {
        if let id = tamagotchi.id {
            imageView.image = UIImage(named: "\(id)-6")
        } else {
            imageView.image = UIImage(resource: .no)
        }
        
        if let name = tamagotchi.name {
            nameLabel.setName(name)
        } else {
            nameLabel.setName("준비중이에요")
        }
    }
}

// MARK: Configure Views
private extension TamagotchiCollectionViewCell {
    func configureUI() {
        configureImageView()
        
        contentView.addSubview(nameLabel)
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureImageView() {
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
    }
}

#Preview {
    SelectionViewController()
}
