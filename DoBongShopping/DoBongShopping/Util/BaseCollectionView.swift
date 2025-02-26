//
//  BaseCollectionView.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/16/25.
//

import UIKit

final class VerticalCollectionView: UICollectionView {
    init(
        superSize: CGRect,
        itemHeight: CGFloat,
        colCount: CGFloat,
        colSpacing: CGFloat,
        rowSpacing: CGFloat,
        inset: UIEdgeInsets
    ) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = inset
        layout.minimumLineSpacing = rowSpacing
        layout.minimumInteritemSpacing = colSpacing
        let width = (superSize.width - (colCount + 1) * colSpacing) / colCount
        layout.itemSize = CGSize(width: width, height: itemHeight)
        
        super.init(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

