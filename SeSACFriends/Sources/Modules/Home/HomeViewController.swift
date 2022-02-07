//
//  HomeViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/05.
//

import UIKit
import CoreLocation
import NMapsMap
import RxSwift
import RxCocoa

class HomeViewController: ViewController {
    
    let mainView = HomeView()
    var locationManager: CLLocationManager!
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        CLLocationManagerDelegate()
        super.viewDidLoad()
    }
    
    override func configure() {
        self.mainView.mapView.updateLocation()
    }
    
    override func bind() {
        mainView.currentLocationButton.rx.tap
            .map(checkLocationAuthorization)
            .filter { $0 }
            .asDriverOnErrorJustComplete()
            .drive { [weak self] _ in
                guard let self = self,
                      let coordinate = self.locationManager.location?.coordinate.NMGLatLng else { return }
                self.mainView.mapView.updateLocation(coordinate: coordinate)
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func CLLocationManagerDelegate() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func checkLocationAuthorization() -> Bool {
        switch locationManager.authorizationStatus {
        case .denied, .restricted:
            let alert = SesacAlertController(title: "위치 서비스 사용 불가", message: "서비스 사용을 위해 설청창으로 이동합니다.") {
                if let bundleId = Bundle.main.bundleIdentifier,
                   let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    self.dismiss(animated: false)
                }
            }
            present(alert, animated: false)
            return false
        default:
            return true
        }
    }
}
