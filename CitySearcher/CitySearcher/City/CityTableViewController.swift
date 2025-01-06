//
//  CityTableViewController.swift
//  CitySearcher
//
//  Created by 김도형 on 1/6/25.
//

import UIKit

class CityTableViewController: UITableViewController {
    @IBOutlet var domesticSegmentControl: UISegmentedControl!
    
    private var cities = CityInfo().city
    
    private var cityList: [City] {
        return cities
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: .cityCell, bundle: nil),
            forCellReuseIdentifier: .cityCell
        )
        
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cityList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: .cityCell,
            for: indexPath
        )
        guard let cityCell = cell as? CityTableViewCell else {
            return cell
        }
        let city = cityList[indexPath.row]
        cityCell.updateCity(city)
        return cityCell
    }

}
