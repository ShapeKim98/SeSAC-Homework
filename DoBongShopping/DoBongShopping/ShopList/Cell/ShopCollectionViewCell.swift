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
        backgroundColor = .clear
        
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(imageView.snp.width).multipliedBy(1)
        }
        
        mallNameLabel.font = .systemFont(ofSize: 12)
        mallNameLabel.textColor = .systemGray4
        contentView.addSubview(mallNameLabel)
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 4
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        lpriceLabel.font = .systemFont(ofSize: 18, weight: .bold)
        lpriceLabel.textColor = .white
        contentView.addSubview(lpriceLabel)
        lpriceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellForItemAt(_ shopItem: ShopResponse.Item) {
        let size = imageView.bounds.size
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: URL(string: shopItem.image),
            options: [
                .processor(DownsamplingImageProcessor(size: size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
        
        mallNameLabel.text = shopItem.mallName.removeHTMLTags()
        
        titleLabel.text = shopItem.title.removeHTMLTags()
        
        guard
            let lprice = Int(shopItem.lprice)?.formatted()
        else { return }
        lpriceLabel.text = lprice
        
    }
    
    func cancelImageDownload() {
        imageView.kf.cancelDownloadTask()
    }
}

extension String {
    static let shopCollectionCell = "ShopCollectionViewCell"
}
