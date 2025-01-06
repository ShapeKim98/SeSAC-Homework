//
//  TravelTableViewCell.swift
//  Travel
//
//  Created by 김도형 on 1/4/25.
//

import UIKit

import Kingfisher

class TravelTableViewCell: UITableViewCell {
    @IBOutlet var seperatorView: UIView!
    @IBOutlet var likeButtonBackgroundImageView: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var saveAndLikeLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var travelImageView: UIImageView!

    
    func setTitleLabel(title: String) {
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .left
    }
    
    func setDescriptionLabel(description: String?) {
        guard let description else { return }
        descriptionLabel.text = description
        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
    }
    
    func setSaveAndLikeLabel(save: Int?, grade: Double?) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard
            let saveString = formatter.string(for: save),
            let grade
        else { return }
        
        saveAndLikeLabel.text = "(\(grade)) ∙ 저장 \(saveString)"
        saveAndLikeLabel.font = .systemFont(ofSize: 10)
        saveAndLikeLabel.textAlignment = .left
        saveAndLikeLabel.textColor = .lightGray
    }
    
    func setLikeButton(like: Bool?, row: Int, target: Any?, action: Selector) {
        let like = like ?? false
        likeButton.setTitle("", for: .normal)
        likeButton.setImage(
            UIImage(systemName: like ? "heart" : "heart.fill"),
            for: .normal
        )
        likeButton.backgroundColor = .clear
        likeButton.tintColor = .white
        likeButton.addTarget(target, action: action, for: .touchUpInside)
        likeButton.tag = row
        
        likeButtonBackgroundImageView.image = UIImage(systemName: "heart.fill")
        likeButtonBackgroundImageView.alpha = 0.3
        likeButtonBackgroundImageView.tintColor = .black
    }
    
    func setTravelImageView(travelImage: String?) {
        guard let travelImage else { return }
        let url = URL(string: travelImage)
        travelImageView.kf.setImage(with: url)
        travelImageView.contentMode = .scaleAspectFill
        travelImageView.layer.cornerRadius = 8
        travelImageView.clipsToBounds = true
    }
    
    func setSeperatorView(row: Int) {
        seperatorView.isHidden = row == 0
        seperatorView.backgroundColor = .systemGray5
    }
}

extension String {
    static let travelCell = "TravelTableViewCell"
}
