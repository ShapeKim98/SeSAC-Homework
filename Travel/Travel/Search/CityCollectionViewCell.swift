//
//  CityCollectionViewCell.swift
//  Travel
//
//  Created by 김도형 on 1/7/25.
//

import UIKit

import Kingfisher

class CityCollectionViewCell: UICollectionViewCell {
    @IBOutlet var cityExplainLabel: UILabel!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var cityImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setCityNameLabel()
        
        setCityExplainLabel()
        
        setCityImageView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = cityImageView.frame.width
        cityImageView.layer.cornerRadius = height / 2
    }
    
    func updateCity(_ city: City, keyword: String) {
        updateCityImageView(cityImage: city.city_image)
        
        let keywords = keyword.split(separator: " ").map {
            String($0)
        }
        
        updateCityNameLabel(
            cityName: city.cityName,
            keywords: keywords
        )
        
        updateCityExplainLabel(
            cityExplain: city.city_explain,
            keywords: keywords
        )
    }
    
    private func highlightAttributedString(text: String, keywords: [String]) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(
            string: text
        )
        for keyword in keywords {
            let range = mutableAttributedString.mutableString.range(
                of: keyword
            )
            mutableAttributedString.addAttributes(
                [.foregroundColor: UIColor.yellow],
                range: range
            )
        }
        return mutableAttributedString
    }
    
    private func setCityNameLabel() {
        cityNameLabel.font = .boldSystemFont(ofSize: 16)
        cityNameLabel.textAlignment = .center
    }
    
    private func setCityExplainLabel() {
        cityExplainLabel.font = .systemFont(ofSize: 12)
        cityExplainLabel.textColor = .secondaryLabel
        cityExplainLabel.numberOfLines = 0
        cityExplainLabel.textAlignment = .center
    }
    
    private func setCityImageView() {
        cityImageView.contentMode = .scaleAspectFill
        cityImageView.clipsToBounds = true
    }
    
    private func updateCityImageView(cityImage: String) {
        let url = URL(string: cityImage)
        cityImageView.kf.setImage(with: url)
    }
    
    private func updateCityNameLabel(cityName: String, keywords: [String]) {
        cityNameLabel.text = cityName
        cityNameLabel.attributedText = highlightAttributedString(
            text: cityName,
            keywords: keywords
        )
    }
    
    private func updateCityExplainLabel(cityExplain: String, keywords: [String]) {
        cityExplainLabel.text = cityExplain
        cityExplainLabel.attributedText = highlightAttributedString(
            text: cityExplain,
            keywords: keywords
        )
    }
}

extension String {
    static let cityCollectionCell = "CityCollectionViewCell"
}
