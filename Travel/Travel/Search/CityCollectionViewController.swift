//
//  CityTableViewController.swift
//  CitySearcher
//
//  Created by 김도형 on 1/6/25.
//

import UIKit

class CityCollectionViewController: UIViewController {
    @IBOutlet
    private var domesticSegmentControl: UISegmentedControl!
    @IBOutlet
    private var cityCollectionView: UICollectionView!
    
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
        didSet { cityCollectionView.reloadData() }
    }
    
    private var keyword: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityCollectionView.dataSource = self
        cityCollectionView.delegate = self
        
        cityCollectionView.register(
            UINib(nibName: .cityCollectionCell, bundle: nil),
            forCellWithReuseIdentifier: .cityCollectionCell
        )
        
        setCollectionViewLayout()
        
        setSearchController()
        
        setDomesticSegmentControl()
    }
    
    private func setCollectionViewLayout() {
        let screenWidth = self.view.frame.width
        let width = (screenWidth - 52) / 2
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: 250)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        cityCollectionView.collectionViewLayout = layout
    }
    
    private func setSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "도시를 입력해 주세요."
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

extension CityCollectionViewController: UISearchResultsUpdating {
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

extension CityCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: .cityCollectionCell,
            for: indexPath
        )
        guard let cityCell = cell as? CityCollectionViewCell else {
            return cell
        }
        let city = cityList[indexPath.row]
        cityCell.updateCity(city, keyword: keyword)
        return cityCell
    }
}

extension CityCollectionViewController: UICollectionViewDelegate {
    
}

extension CityCollectionViewController {
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
