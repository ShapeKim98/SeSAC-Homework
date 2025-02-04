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
    private var continuation: CheckedContinuation<(CLLocationCoordinate2D?, CLAuthorizationStatus?), Never>?
    
    private override init() {
        super.init()
        manager.delegate = self
    }
    
    func fetchLocation() async -> (CLLocationCoordinate2D?, CLAuthorizationStatus?) {
        guard continuation == nil else { return (nil, nil) }
        
        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            Task { await checkLocationServicesEnabled() }
        }
    }
}

private extension LocationManager {
    func checkLocationServicesEnabled() async {
        guard CLLocationManager.locationServicesEnabled() else {
            await MainActor.run {
                resumeContinuation(defaultLocation, manager.authorizationStatus)
            }
            return
        }
        await checkAuthorizationStatus()
    }
    
    @MainActor
    func checkAuthorizationStatus() {
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied:
            resumeContinuation(defaultLocation, .denied)
        default:
            resumeContinuation(defaultLocation, status)
        }
    }
    
    func resumeContinuation(
        _ location: CLLocationCoordinate2D,
        _ status: CLAuthorizationStatus?
    ) {
        self.continuation?.resume(returning: (location, status))
        self.continuation = nil
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else {
            resumeContinuation(defaultLocation, manager.authorizationStatus)
            return
        }
        resumeContinuation(location, .authorizedWhenInUse)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        resumeContinuation(defaultLocation, manager.authorizationStatus)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard continuation != nil else { return }
        Task { await checkLocationServicesEnabled() }
    }
}
