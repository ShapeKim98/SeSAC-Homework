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
    
    func setPhotoImageView(photoImage: String) {
        let url = URL(string: photoImage)
        photoImageView.kf.setImage(with: url)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = 12
        photoImageView.clipsToBounds = true
    }
    
    func setTitleLabel(title: String) {
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
    }
    
    func setSubtitleLabel(subtitle: String) {
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.numberOfLines = 1
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .left
    }
    
    func setDateLabel(dateString: String) {
        guard
            let numberOnlyFormatter = DateStyle.cachedDateFormatter[.numberOnly],
            let date = numberOnlyFormatter.date(from: dateString),
            let numberAndStringFormatter = DateStyle.cachedDateFormatter[.numberAndString]
        else { return }
        
        let formattedDate = numberAndStringFormatter.string(from: date)
        
        dateLabel.text = formattedDate
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.numberOfLines = 1
        dateLabel.textColor = .secondaryLabel
        dateLabel.textAlignment = .right
    }
}

extension String {
    static let magazineCell = "MagazineTableViewCell"
}
