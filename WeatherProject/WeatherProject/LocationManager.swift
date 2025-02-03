//
//  LocationManager.swift
//  WeatherProject
//
//  Created by 김도형 on 2/3/25.
//

import CoreLocation

final class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    private let defaultLocation = CLLocationCoordinate2D(
        latitude: 37.6545021055909,
        longitude: 127.049672533607
    )
    private var continuation: CheckedContinuation<(CLLocationCoordinate2D, CLAuthorizationStatus?), Never>?
    
    private override init() {
        super.init()
        manager.delegate = self
    }
    
    func fetchLocation() async -> (CLLocationCoordinate2D, CLAuthorizationStatus?) {
        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            Task { await checkLocationServicesEnabled() }
        }
    }
}

private extension LocationManager {
    func checkLocationServicesEnabled() async {
        guard CLLocationManager.locationServicesEnabled() else {
            continuation?.resume(returning: (defaultLocation, .denied))
            self.continuation = nil
            return
        }
        await checkAuthorizationStatus()
    }
    
    @MainActor
    func checkAuthorizationStatus() {
        print(#function, Thread.isMainThread)
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied:
            continuation?.resume(returning: (defaultLocation, .denied))
            self.continuation = nil
        default:
            self.continuation?.resume(returning: (defaultLocation, nil))
            self.continuation = nil
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else {
            continuation?.resume(returning: (defaultLocation, nil))
            continuation = nil
            return
        }
        self.continuation?.resume(returning: (location, .authorizedWhenInUse))
        self.continuation = nil
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        self.continuation?.resume(returning: (defaultLocation, nil))
        self.continuation = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { await checkLocationServicesEnabled() }
    }
}
