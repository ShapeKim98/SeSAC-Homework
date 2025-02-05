//
//  PhotoCollectionViewCell.swift
//  WeatherProject
//
//  Created by 김도형 on 2/4/25.
//

import UIKit

import SnapKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func forItemAt(_ image: UIImage?) {
        imageView.image = image
    }
}

extension String {
    static let photoCollectionCell = "PhotoCollectionViewCell"
}
