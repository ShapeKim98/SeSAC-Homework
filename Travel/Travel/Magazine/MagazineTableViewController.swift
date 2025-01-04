//
//  MagazineTableViewController.swift
//  Travel
//
//  Created by 김도형 on 1/4/25.
//

import UIKit

import Kingfisher

class MagazineTableViewController: UITableViewController {
    private let magazineList = MagazineInfo().magazine
    private let cachedDateFormatter = DateStyle.cachedDateFormatter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return magazineList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: .magazineCell,
            for: indexPath
        )
        guard let magazineCell = cell as? MagazineTableViewCell else {
            return cell
        }
        
        let magazine = magazineList[indexPath.row]
        
        setPhotoImageView(
            imageView: magazineCell.photoImageView,
            photoImage: magazine.photo_image
        )
        
        setTitleLabel(
            label: magazineCell.titleLabel,
            text: magazine.title
        )
        
        setSubtitleLabel(
            label: magazineCell.subtitleLabel,
            text: magazine.subtitle
        )
        
        setDateLabel(
            label: magazineCell.dateLabel,
            text: magazine.date
        )
        
        return magazineCell
    }
    
    private func setPhotoImageView(imageView: UIImageView, photoImage: String) {
        let url = URL(string: photoImage)
        imageView.kf.setImage(with: url)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
    }
    
    private func setTitleLabel(label: UILabel, text: String) {
        label.text = text
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .left
    }
    
    private func setSubtitleLabel(label: UILabel, text: String) {
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.textAlignment = .left
    }
    
    private func setDateLabel(label: UILabel, text: String) {
        guard
            let numberOnlyFormatter = cachedDateFormatter[.numberOnly],
            let date = numberOnlyFormatter.date(from: text),
            let numberAndStringFormatter = cachedDateFormatter[.numberAndString]
        else { return }
        
        let formattedDate = numberAndStringFormatter.string(from: date)
        
        label.text = formattedDate
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.textAlignment = .right
    }
}

extension MagazineTableViewController {
    enum DateStyle: String, CaseIterable {
        case numberOnly = "yyMMdd"
        case numberAndString = "yy년 MM월 dd일"
        
        static var cachedDateFormatter: [DateStyle: DateFormatter] {
            var cachedFormatter = [DateStyle: DateFormatter]()
            
            for style in Self.allCases {
                let formatter = DateFormatter()
                formatter.dateFormat = style.rawValue
                cachedFormatter[style] = formatter
            }
            
            return cachedFormatter
        }
    }
}
