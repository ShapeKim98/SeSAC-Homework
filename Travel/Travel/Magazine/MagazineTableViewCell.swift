//
//  MagazineTableViewCell.swift
//  Travel
//
//  Created by 김도형 on 1/4/25.
//

import UIKit

import Kingfisher

class MagazineTableViewCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setPhotoImageView()
        
        setTitleLabel()
        
        setSubtitleLabel()
        
        setDateLabel()
    }
    
    func updateMagazine(_ magazine: Magazine) {
        updatePhotoImageView(photoImage: magazine.photo_image)
        updateTitleLabel(title: magazine.title)
        updateSubtitleLabel(subtitle: magazine.subtitle)
        updateDateLabel(dateString: magazine.date)
    }
    
    private func updatePhotoImageView(photoImage: String) {
        let url = URL(string: photoImage)
        photoImageView.kf.setImage(with: url)
    }
    
    private func updateTitleLabel(title: String) {
        titleLabel.text = title
    }
    
    private func updateSubtitleLabel(subtitle: String) {
        subtitleLabel.text = subtitle
    }
    
    private func updateDateLabel(dateString: String) {
        guard
            let numberOnlyFormatter = DateStyle.cachedDateFormatter[.numberOnly],
            let date = numberOnlyFormatter.date(from: dateString),
            let numberAndStringFormatter = DateStyle.cachedDateFormatter[.numberAndString]
        else { return }
        
        let formattedDate = numberAndStringFormatter.string(from: date)
        
        dateLabel.text = formattedDate
    }
    
    private func setPhotoImageView() {
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = 12
        photoImageView.clipsToBounds = true
    }
    
    private func setDateLabel() {
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.numberOfLines = 1
        dateLabel.textColor = .secondaryLabel
        dateLabel.textAlignment = .right
    }
    
    private func setTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
    }
    
    private func setSubtitleLabel() {
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.numberOfLines = 1
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .left
    }
}

extension String {
    static let magazineCell = "MagazineTableViewCell"
}
