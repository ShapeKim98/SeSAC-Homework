//
//  TravelTableViewController.swift
//  Travel
//
//  Created by 김도형 on 1/4/25.
//

import UIKit

class TravelTableViewController: UITableViewController {
    private var travelList = TravelInfo().travel

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travelList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let travel = travelList[indexPath.row]
        let isAd = travel.ad ?? false ||
        travel.description == nil ||
        travel.travel_image == nil ||
        travel.grade == nil ||
        travel.save == nil ||
        travel.like == nil
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: isAd ? .adCell : .travelCell,
            for: indexPath
        )
        
        isAd ?
        setAdTableViewCell(cell, title: travel.title) :
        setTravelTableViewCell(cell, row: indexPath.row, travel: travel)
        
        return cell
    }
    
    private func setTravelTableViewCell(_ cell: UITableViewCell, row: Int, travel: Travel) {
        guard let travelCell = cell as? TravelTableViewCell else { return }
        
        travelCell.updateTravel(travel)
        travelCell.updateSeparatorView(row: row)
        travelCell.updateLikeButton(
            like: travel.like,
            row: row,
            target: self,
            action: #selector(likeButtonTouchUpInside)
        )
    }
    
    private func setAdTableViewCell(_ cell: UITableViewCell, title: String) {
        guard let adCell = cell as? AdTableViewCell else { return }
        
        adCell.updateTitleLabel(title)
    }
    
    @objc
    private func likeButtonTouchUpInside(_ sender: UIButton) {
        travelList[sender.tag].like?.toggle()
        tableView.reloadRows(
            at: [.init(row: sender.tag, section: 0)],
            with: .automatic
        )
    }
}
