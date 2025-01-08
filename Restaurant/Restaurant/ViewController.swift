//
//  ViewController.swift
//  Restaurant
//
//  Created by 김도형 on 1/8/25.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet
    private var mapView: MKMapView!
    
    private var currentCategory = Category.전체
    private var restaurants: [Restaurant] {
        let list = RestaurantList().restaurantArray
        
        if case .전체 = currentCategory {
            return list
        } else {
            return list.filter { restaurant in
                restaurant.category == currentCategory.rawValue
            }
        }
    }
    
    private var annotations: [MKPointAnnotation] {
        let annotations = restaurants.map { restaurant in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: restaurant.latitude,
                longitude: restaurant.longitude
            )
            annotation.title = restaurant.name
            return annotation
        }
        return annotations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureNavigationBar()
        
        configureMapView()
    }
    
    private func configureNavigationBar() {
        navigationController?
            .navigationBar
            .topItem?
            .rightBarButtonItem = UIBarButtonItem(
                title: "Filter",
                style: .plain,
                target: self,
                action: #selector(filterButtonTouchUpInside)
            )
    }

    private func configureMapView() {
        guard
            let maxLatitude = restaurants.maxLatitude,
            let maxLongitude = restaurants.maxLongitude,
            let minLatitude = restaurants.minLatitude,
            let minLongitude = restaurants.minLongitude
        else { return }
        
        let center = updateCenter(
            maxLatitude: maxLatitude,
            maxLongitude: maxLongitude,
            minLatitude: minLatitude,
            minLongitude: minLongitude
        )
        
        let maxLocation = CLLocation(
            latitude: maxLatitude,
            longitude: maxLongitude
        )
        let minLocation = CLLocation(
            latitude: minLatitude,
            longitude: minLongitude
        )
        let distance = maxLocation.distance(from: minLocation)
        
        mapView.region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: distance,
            longitudinalMeters: distance
        )
        mapView.addAnnotations(annotations)
    }
    
    private func updateCenter(
        maxLatitude: Double,
        maxLongitude: Double,
        minLatitude: Double,
        minLongitude: Double
    ) -> CLLocationCoordinate2D {
        let latitude = minLatitude + ((maxLatitude - minLatitude) / 2)
        let longitude = minLongitude + ((maxLongitude - minLongitude) / 2)
        
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
    
    private func alertActionHandler(_ alertAction: UIAlertAction) {
        guard
            let title = alertAction.title,
            let category = Category(rawValue: title)
        else { return }
        currentCategory = category
        mapView.removeAnnotations(mapView.annotations)
        configureMapView()
    }
    
    @objc
    private func filterButtonTouchUpInside() {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        
        for category in Category.allCases {
            let action = UIAlertAction(
                title: category.rawValue,
                style: .default,
                handler: alertActionHandler
            )
            alert.addAction(action)
        }
        present(alert, animated: true)
    }
}

extension ViewController {
    enum Category: String, CaseIterable {
        case 전체 = "전체"
        case 한식 = "한식"
        case 양식 = "양식"
        case 분식 = "분식"
        case 카페 = "카페"
        case 샐러드 = "샐러드"
        case 중식 = "중식"
        case 일식 = "일식"
    }
}
