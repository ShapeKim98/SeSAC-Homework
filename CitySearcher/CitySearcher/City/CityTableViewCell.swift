//
//  CityTableViewCell.swift
//  CitySearcher
//
//  Created by 김도형 on 1/6/25.
//

import UIKit

import Kingfisher

class CityTableViewCell: UITableViewCell {
    @IBOutlet var cityExplainLabel: UILabel!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var cityImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCityNameLabel()
    }
    
    func updateCity(_ city: City) {
        updateCityImageView(cityImage: city.city_image)
        
        updateCityNameLabel(cityName: city.cityName)
        
        updateCityExplainLabel(cityExplain: city.city_explain)
    }
    
    private func setCityNameLabel() {
        cityNameLabel.font = .boldSystemFont(ofSize: 20)
        cityNameLabel.textColor = .white
        cityNameLabel.textAlignment = .right
    }
    
    private func setCityExplainLabel() {
        cityExplainLabel.font = .systemFont(ofSize: 14)
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        cityExplainLabel.backgroundColor = color
    }
    
    private func updateCityImageView(cityImage: String) {
        let url = URL(string: cityImage)
        cityImageView.kf.setImage(with: url)
        cityImageView.contentMode = .scaleAspectFill
        cityImageView.clipsToBounds = true
    }
    
    private func updateCityNameLabel(cityName: String) {
        cityNameLabel.text = cityName
    }
    
    private func updateCityExplainLabel(cityExplain: String) {
        cityExplainLabel.text = cityExplain
    }
}

extension String {
    static let cityCell = "CityTableViewCell"
}
