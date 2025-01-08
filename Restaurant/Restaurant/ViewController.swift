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
        
        switch currentCategory {
        case .전체: return list
        case .한식: return list.filter { $0.category == "한식" }
        case .양식: return list.filter { $0.category == "양식" }
        }
    }
    private var annotations: [MKPointAnnotation] {
        let annotations = restaurants.map { restaurant in
            var annotation = MKPointAnnotation()
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
        
        configureMapView()
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
}

extension ViewController {
    enum Category {
        case 전체
        case 한식
        case 양식
    }
}
