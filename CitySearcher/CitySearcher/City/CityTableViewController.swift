//
//  CityTableViewController.swift
//  CitySearcher
//
//  Created by 김도형 on 1/6/25.
//

import UIKit

class CityTableViewController: UITableViewController {
    @IBOutlet
    private var domesticSegmentControl: UISegmentedControl!
    
    private var domestic = DomesticSegment.all {
        didSet {
            let cities = CityInfo().city
            switch domestic {
            case .all: cityList = cities
            case .isDomestic:
                return cityList = cities.filter(\.domestic_travel)
            case .isNotDomestic:
                return cityList = cities.filter { !$0.domestic_travel }
            }
        }
    }
    
    private var cityList: [City] = CityInfo().city {
        didSet { tableView.reloadData() }
    }
    
    private var keyword: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: .cityCell, bundle: nil),
            forCellReuseIdentifier: .cityCell
        )
        
        setSearchController()
        
        tableView.separatorStyle = .none
        
        setDomesticSegmentControl()
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
        cityCell.updateCity(city, keyword: keyword)
        return cityCell
    }
    
    private func setSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
    }
    
    private func setDomesticSegmentControl() {
        domesticSegmentControl.removeAllSegments()
        
        for domestic in DomesticSegment.allCases {
            domesticSegmentControl.insertSegment(
                withTitle: domestic.title,
                at: domestic.rawValue,
                animated: true
            )
        }
        domesticSegmentControl.selectedSegmentIndex = domestic.rawValue
    }
    
    @IBAction func domesticSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        let domesticType = DomesticSegment(rawValue: sender.selectedSegmentIndex)
        guard let domesticType else { return }
        domestic = domesticType
    }
}

extension CityTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        keyword = text
        cityList = CityInfo().city.filter({ city in
            switch domestic {
            case .all: return city.isContains(keyword: text)
            case .isDomestic:
                return city.domestic_travel &&
                city.isContains(keyword: text)
            case .isNotDomestic:
                return !city.domestic_travel &&
                city.isContains(keyword: text)
            }
        })
    }
}

extension CityTableViewController {
    fileprivate enum DomesticSegment: Int, CaseIterable {
        case all
        case isDomestic
        case isNotDomestic
        
        var title: String {
            switch self {
            case .all: return "전체"
            case .isDomestic: return "국내"
            case .isNotDomestic: return "해외"
            }
        }
    }
}
