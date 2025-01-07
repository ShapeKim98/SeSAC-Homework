//
//  CityTableViewCell.swift
//  CitySearcher
//
//  Created by 김도형 on 1/6/25.
//

import UIKit

import Kingfisher

class CityTableViewCell: UITableViewCell {
    @IBOutlet var cityExplainBackgroundView: UIView!
    @IBOutlet var cityExplainLabel: UILabel!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var cityImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCityNameLabel()
        
        setCityExplainLabel()
        
        setCityExplainBackgroundView()
        
        setCityImageView()
    }
    
    func updateCity(_ city: City, keyword: String) {
        updateCityImageView(cityImage: city.city_image)
        
        let keywords = keyword.split(separator: " ").map { String($0) }
        
        updateCityNameLabel(cityName: city.cityName, keywords: keywords)
        
        updateCityExplainLabel(cityExplain: city.city_explain, keywords: keywords)
    }
    
    private func highlightAttributedString(text: String, keywords: [String]) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: text)
        for keyword in keywords {
            let range = mutableAttributedString.mutableString.range(of: keyword)
            mutableAttributedString.addAttributes(
                [.foregroundColor: UIColor.yellow],
                range: range
            )
        }
        return mutableAttributedString
    }
    
    private func setCityNameLabel() {
        cityNameLabel.font = .boldSystemFont(ofSize: 20)
        cityNameLabel.textColor = .white
        cityNameLabel.textAlignment = .right
    }
    
    private func setCityExplainLabel() {
        cityExplainLabel.font = .systemFont(ofSize: 14)
        cityExplainLabel.textColor = .white
        cityExplainLabel.numberOfLines = 0
    }
    
    private func setCityExplainBackgroundView() {
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        cityExplainBackgroundView.backgroundColor = color
        cityExplainBackgroundView.layer.cornerRadius = 16
        cityExplainBackgroundView.layer.maskedCorners = [
            .layerMaxXMaxYCorner
        ]
        cityExplainBackgroundView.clipsToBounds = true
    }
    
    private func setCityImageView() {
        cityImageView.contentMode = .scaleAspectFill
        cityImageView.layer.cornerRadius = 16
        cityImageView.layer.maskedCorners = [
            .layerMaxXMaxYCorner,
            .layerMinXMinYCorner
        ]
        cityImageView.clipsToBounds = true
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: 5, height: 5)
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
    static let cityCell = "CityTableViewCell"
}
