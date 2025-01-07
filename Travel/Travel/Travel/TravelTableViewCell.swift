//
//  TravelTableViewCell.swift
//  Travel
//
//  Created by 김도형 on 1/4/25.
//

import UIKit

import Kingfisher

class TravelTableViewCell: UITableViewCell {
    @IBOutlet
    private var separatorView: UIView!
    @IBOutlet
    private var likeButtonBackgroundImageView: UIImageView!
    @IBOutlet
    private var likeButton: UIButton!
    @IBOutlet
    private var saveAndLikeLabel: UILabel!
    @IBOutlet
    private var descriptionLabel: UILabel!
    @IBOutlet
    private var titleLabel: UILabel!
    @IBOutlet
    private var travelImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setTitleLabel()
        
        setDescriptionLabel()
        
        setSaveAndLikeLabel()
        
        setLikeButton()
        
        setTravelImageView()
        
        separatorView.backgroundColor = .systemGray5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        likeButtonReused()
    }
    
    func updateTravel(_ travel: Travel) {
        updateTitleLabel(title: travel.title)
        
        updateDescriptionLabel(description: travel.description)
        
        updateSaveAndLikeLabel(save: travel.save, grade: travel.grade)
        
        updateTravelImageView(travelImage: travel.travel_image)
    }
    
    func updateLikeButton(like: Bool?, row: Int, target: Any?, action: Selector) {
        if let like, like {
            likeButton.setImage(
                UIImage(systemName: "heart.fill"),
                for: .normal
            )
        }
        likeButton.tag = row
        likeButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func updateSeparatorView(row: Int) {
        separatorView.isHidden = row == 0
    }
    
    private func updateTitleLabel(title: String) {
        titleLabel.text = title
    }
    
    private func updateDescriptionLabel(description: String?) {
        guard let description else { return }
        descriptionLabel.text = description
    }
    
    private func updateSaveAndLikeLabel(save: Int?, grade: Double?) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard
            let saveString = formatter.string(for: save),
            let grade
        else { return }
        
        saveAndLikeLabel.text = "(\(grade)) ∙ 저장 \(saveString)"
    }
    
    private func updateTravelImageView(travelImage: String?) {
        guard let travelImage else { return }
        let url = URL(string: travelImage)
        travelImageView.kf.setImage(with: url)
    }
    
    private func setTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .left
    }
    
    private func setDescriptionLabel() {
        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
    }
    
    private func setSaveAndLikeLabel() {
        saveAndLikeLabel.font = .systemFont(ofSize: 10)
        saveAndLikeLabel.textAlignment = .left
        saveAndLikeLabel.textColor = .lightGray
    }
    
    private func setLikeButton() {
        likeButton.setTitle("", for: .normal)
        likeButton.backgroundColor = .clear
        likeButton.tintColor = .white
        likeButton.setImage(
            UIImage(systemName: "heart"),
            for: .normal
        )
        
        likeButtonBackgroundImageView.image = UIImage(systemName: "heart.fill")
        likeButtonBackgroundImageView.alpha = 0.3
        likeButtonBackgroundImageView.tintColor = .black
    }
    
    private func likeButtonReused() {
        likeButton.setImage(
            UIImage(systemName: "heart"),
            for: .normal
        )
    }
    
    private func setTravelImageView() {
        travelImageView.contentMode = .scaleAspectFill
        travelImageView.layer.cornerRadius = 8
        travelImageView.clipsToBounds = true
    }
}

extension String {
    static let travelCell = "TravelTableViewCell"
}
