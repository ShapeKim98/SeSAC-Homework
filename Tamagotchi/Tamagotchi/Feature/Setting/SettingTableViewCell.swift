//
//  SettingTableViewCell.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/23/25.
//

import UIKit

import SnapKit

final class SettingTableViewCell: UITableViewCell {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let nameLabel = UILabel()
    private let chevronImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func forRowAt(_ item: SettingViewModel.SettingItem) {
        iconImageView.image = UIImage(systemName: item.imageName)
        titleLabel.text = item.title
        nameLabel.text = item.name
    }
}

// MARK: Configure Views
private extension SettingTableViewCell {
    func configureUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        configureIconImageView()
        
        configureTitleLabel()
        
        configureNameLabel()
        
        configureChevronImageView()
    }
    
    func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(24).priority(.high)
            make.leading.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.centerY.equalTo(iconImageView)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(iconImageView)
            make.size.equalTo(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
            make.centerY.equalTo(chevronImageView)
        }
    }
    
    func configureIconImageView() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .accent
        contentView.addSubview(iconImageView)
    }
    
    func configureTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .black
        contentView.addSubview(titleLabel)
    }
    
    func configureNameLabel() {
        nameLabel.font = .systemFont(ofSize: 16, weight: .regular)
        nameLabel.textColor = .systemGray
        contentView.addSubview(nameLabel)
    }
    
    func configureChevronImageView() {
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .systemGray
        contentView.addSubview(chevronImageView)
    }
}
