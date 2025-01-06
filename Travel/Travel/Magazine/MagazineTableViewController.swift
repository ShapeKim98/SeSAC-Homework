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
        
        magazineCell.setPhotoImageView(photoImage: magazine.photo_image)
        magazineCell.setTitleLabel(title: magazine.title)
        magazineCell.setSubtitleLabel(subtitle: magazine.subtitle)
        magazineCell.setDateLabel(dateString: magazine.date)
        
        return magazineCell
    }
}

