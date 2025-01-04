//
//  MagazineTableViewCell.swift
//  Travel
//
//  Created by 김도형 on 1/4/25.
//

import UIKit

class MagazineTableViewCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var photoImageView: UIImageView!
}

extension String {
    static let magazineCell = "MagazineTableViewCell"
}
