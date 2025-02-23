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
    private let nameLabelContainer = UIView()
    private let nameLabel = UILabel()
    
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
            nameLabel.text = name
        } else {
            nameLabel.text = "준비중이에요"
        }
    }
}

// MARK: Configure Views
private extension TamagotchiCollectionViewCell {
    func configureUI() {
        configureImageView()
        
        configureNameLabel()
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        nameLabelContainer.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
    }
    
    func configureImageView() {
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
    }
    
    func configureNameLabel() {
        nameLabelContainer.backgroundColor = .tgBackground
        nameLabelContainer.layer.cornerRadius = 4
        nameLabelContainer.layer.borderColor = UIColor(resource: .accent).cgColor
        nameLabelContainer.layer.borderWidth = 1
        nameLabelContainer.clipsToBounds = true
        contentView.addSubview(nameLabelContainer)
        
        nameLabel.textColor = .accent
        nameLabel.font = .systemFont(ofSize: 12, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabelContainer.addSubview(nameLabel)
    }
}

#Preview {
    SelectionViewController()
}
