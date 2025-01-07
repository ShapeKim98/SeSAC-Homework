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
        let isAd = isAd(travel)
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: isAd ? .adCell : .travelCell,
            for: indexPath
        )
        
        isAd ?
        setAdTableViewCell(cell, title: travel.title) :
        setTravelTableViewCell(cell, row: indexPath.row, travel: travel)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let travel = travelList[indexPath.row]
        
        isAd(travel)
        ? presentAdViewController(travel)
        : pushTouristViewController(travel)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
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
    
    private func isAd(_ travel: Travel) -> Bool {
        return travel.ad ?? false ||
        travel.description == nil ||
        travel.travel_image == nil ||
        travel.grade == nil ||
        travel.save == nil ||
        travel.like == nil
    }
    
    private func pushTouristViewController(_ travel: Travel) {
        let viewController = storyboard?.instantiateViewController(
            withIdentifier: .touristController
        ) as? TouristViewController
        guard let viewController else { return }
        
        viewController.setTravel(travel)
        
        navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }
    
    private func presentAdViewController(_ travel: Travel) {
        let viewController = storyboard?.instantiateViewController(
            withIdentifier: .adController
        ) as? AdViewController
        guard let viewController else { return }
        
        viewController.setTitleText(title: travel.title)
        let navigationController = UINavigationController(
            rootViewController: viewController
        )
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true)
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
