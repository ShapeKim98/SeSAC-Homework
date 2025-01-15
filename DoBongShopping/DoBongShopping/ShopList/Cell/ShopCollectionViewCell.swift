//
//  ShopCollectionViewCell.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import UIKit

import Kingfisher
import SnapKit

class ShopCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let mallNameLabel = UILabel()
    private let titleLabel = UILabel()
    private let lpriceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellForItemAt(_ shopItem: Shop.Item) {
        backgroundColor = .clear
        
        imageView.kf.setImage(with: URL(string: shopItem.image))
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(imageView.snp.width).multipliedBy(1)
        }
        
        mallNameLabel.text = shopItem.mallName
        mallNameLabel.font = .systemFont(ofSize: 12)
        mallNameLabel.textColor = .secondaryLabel
        contentView.addSubview(mallNameLabel)
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        titleLabel.text = shopItem.title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        lpriceLabel.text = shopItem.lprice
        lpriceLabel.font = .systemFont(ofSize: 18, weight: .bold)
        lpriceLabel.textColor = .white
        contentView.addSubview(lpriceLabel)
        lpriceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
    }
}

extension String {
    static let shopCollectionCell = "ShopCollectionViewCell"
}
