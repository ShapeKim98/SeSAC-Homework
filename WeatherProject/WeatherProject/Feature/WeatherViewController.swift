//
//  WeatherViewController.swift
//  SeSACSevenWeek
//
//  Created by Jack on 2/3/25.
//

import UIKit
import MapKit
import CoreLocation

import SnapKit

final class WeatherViewController: UIViewController {
    private let mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    private let weatherInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.text = "날씨 정보를 불러오는 중..."
        return label
    }()
    
    private let currentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        return button
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        return button
    }()
    
    private let locationManager = LocationManager.shared
    
    private var weather: Weather? {
        didSet { didSetWeather() }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupActions()
        
        Task {
            await fetchLocation()
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        [mapView, weatherInfoLabel, currentLocationButton, refreshButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        weatherInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
    }
    
    private func setupActions() {
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func currentLocationButtonTapped() {
        // 현재 위치 가져오기 구현
        Task {
            guard await fetchLocation() else {
                presentAlert()
                return
            }
        }
    }
    
    @objc private func refreshButtonTapped() {
        // 날씨 새로고침 구현
        Task {
            let center = mapView.centerCoordinate
            await fetchWeather(center)
        }
    }
    
    private func presentAlert() {
        let alert = UIAlertController(
            title: "위치 정보 사용 설정",
            message: "내 위치 확인을 위해 설정에서 위치 정보 사용을 허용해 주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "설정",
            style: .default,
            handler: openSettings
        ))
        alert.addAction(UIAlertAction(
            title: "취소",
            style: .cancel
        ))
        present(alert, animated: true)
    }
    
    private func openSettings(_ action: UIAlertAction) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    @discardableResult
    private func fetchLocation() async -> Bool {
        let (location, status) = await locationManager.fetchLocation()
        Task { await fetchWeather(location) }
        let region = MKCoordinateRegion(
            center: location,
            latitudinalMeters: 200,
            longitudinalMeters: 200
        )
        self.mapView.setRegion(region, animated: true)
        
        let oldAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(oldAnnotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.mapView.addAnnotation(annotation)
        
        return status == .authorizedWhenInUse
    }
    
    private func fetchWeather(_ location: CLLocationCoordinate2D) async {
        do {
            weather = nil
            weather = try await WeatherClient.shared.fetchWeather(
                WeatherRequest(lat: location.latitude, lon: location.longitude)
            )
        } catch {
            print(error)
        }
    }
    
    @MainActor
    private func didSetWeather() {
        guard let weather else {
            weatherInfoLabel.text = "날씨 정보를 불러오는 중..."
            return
        }
        weatherInfoLabel.text = """
        \(Date(timeIntervalSince1970: weather.dt).toString(format: .yyyy년_M월_d일))
        현재온도: \(weather.main.temp)°C
        최저온도: \(weather.main.tempMin)°C
        최고온도: \(weather.main.tempMax)°C
        풍속: \(weather.wind.speed)m/s
        습도: \(weather.main.humidity)%
        """
    }
}

#Preview {
    WeatherViewController()
}
