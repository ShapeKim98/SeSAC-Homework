//
//  ShopCollectionViewCell.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import UIKit

import Kingfisher
import SnapKit
import RxSwift
import RxCocoa
import RealmSwift

@MainActor
protocol ShopCollectionViewCellDelegate: AnyObject {
    func shopItemTableDelete(_ shopItem: ShopResponse.Item)
    func shopItemTableCreate(_ shopItem: ShopResponse.Item)
}

final class ShopCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let mallNameLabel = UILabel()
    private let titleLabel = UILabel()
    private let lpriceLabel = UILabel()
    private let favoriteButton = UIButton()
    
    @RealmTable
    var shopItemTable: Results<ShopItemTable>
    
    private var disposeBag = DisposeBag()
    
    weak var delegate: ShopCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
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
        
        let isSelected = $shopItemTable.findObject(shopItem.productId) != nil
        favoriteButton.isSelected = isSelected
        
        favoriteButton.rx.tap
            .withUnretained(self)
            .map { this, _ in this.$shopItemTable.findObject(shopItem.productId) }
            .bind(with: self) { this, item in
                do {
                    if let item {
                        try this.$shopItemTable.delete(item)
                        this.delegate?.shopItemTableDelete(shopItem)
                    } else {
                        try this.$shopItemTable.create(shopItem.toObject())
                        this.delegate?.shopItemTableCreate(shopItem)
                    }
                } catch {
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        $shopItemTable.observable
            .map { realm in
                realm.object(
                    ofType: ShopItemTable.self,
                    forPrimaryKey: shopItem.productId
                ) != nil
            }
            .bind(to: favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
    
    func cancelImageDownload() {
        imageView.kf.cancelDownloadTask()
    }
}

private extension ShopCollectionViewCell {
    func configureUI() {
        configureImageView()
        
        configureMallNameLabel()
        
        configureTitleLabel()
        
        configureLPriceLabel()
        
        configureFavoriteButton()
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(imageView.snp.width).multipliedBy(1)
        }
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        lpriceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(imageView).inset(8)
        }
    }
    
    func configureImageView() {
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    func configureMallNameLabel() {
        mallNameLabel.font = .systemFont(ofSize: 12)
        mallNameLabel.textColor = .systemGray4
        contentView.addSubview(mallNameLabel)
    }
    
    func configureTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 4
        contentView.addSubview(titleLabel)
    }
    
    func configureLPriceLabel() {
        lpriceLabel.font = .systemFont(ofSize: 18, weight: .bold)
        lpriceLabel.textColor = .white
        contentView.addSubview(lpriceLabel)
    }
    
    func configureFavoriteButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = .clear
        configuration.image = UIImage(systemName: "heart")
        configuration.image?.withTintColor(.systemBlue)
        favoriteButton.configuration = configuration
        favoriteButton.tintColor = .systemBlue
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        favoriteButton.configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.image = UIImage(systemName: "heart.fill")
            default:
                button.configuration?.image = UIImage(systemName: "heart")
            }
        }
        
        contentView.addSubview(favoriteButton)
    }
}

extension String {
    static let shopCollectionCell = "ShopCollectionViewCell"
}
