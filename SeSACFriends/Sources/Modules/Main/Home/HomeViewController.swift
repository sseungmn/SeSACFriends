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
    var viewModel = HomeViewModel()
    var locationManager: CLLocationManager!
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        CLLocationManagerDelegate()
        super.viewDidLoad()
    }
    
    override func configure() {
//        checkLocationAuthorization()
//        self.mainView.mapView.updateLocation(coordinate: locationManager.location?.coordinate.NMGLatLng)
        self.mainView.mapView.updateLocation()
        self.mainView.mapView.setZoomLevel()
    }
    
    override func bind() {
        let input = HomeViewModel.Input(
            curCoordinates: mainView.mapView.rx.curCoordinates,
            viewWillAppear: rx.viewDidLoad.asObservable(),
            gpsButtonTrigger: mainView.gpsButton.rx.tap.asObservable(),
            mapViewIdleTrigger: mainView.mapView.rx.mapViewIdleState.asDriverOnErrorJustComplete(),
            filteredGender: mainView.genderFilterView.filteredGender.asObservable(),
            curAuthorizationState: locationManager.rx.curAuthrizationState.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        output.queuedUsers
            .drive(onNext: { (users) in
                MarkerManager.shared.clearMarkers()
                users.forEach { user in
                    debug(title: "user", user)
                    let marker = NMFMarker(
                        position: NMGLatLng(lat: user.lat, lng: user.long),
                        iconImage: MarkerManager.shared.markerImage(sesacCharacter: user.sesac.sesacCharacter)
                    )
                    MarkerManager.shared.markers.insert(marker)
                }
            })
            .disposed(by: disposeBag)
        
        output.isUserInteractionEnabledMap
            .emit(to: self.mainView.mapView.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
       
        output.updateCameraToCurrentLocation
            .drive { [weak self] _ in
                guard let self = self,
                      let coordinate = self.locationManager.location?.coordinate.NMGLatLng else { return }
                self.mainView.mapView.updateLocation(coordinate: coordinate)
            }
            .disposed(by: disposeBag)
        
        output.requestLocationAuthorization
            .emit { [weak self] _ in
                let alert = SesacAlertController(title: "위치 서비스 사용 불가", message: "서비스 사용을 위해 설청창으로 이동합니다.") {
                    if let bundleId = Bundle.main.bundleIdentifier,
                       let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        self?.dismiss(animated: false)
                    }
                }
                self?.present(alert, animated: false)
            }
            .disposed(by: disposeBag)
        
//        mainView.gpsButton.rx.tap
//            .map(checkLocationAuthorization)
//            .filter { $0 }
//            .asDriverOnErrorJustComplete()
//            .disposed(by: disposeBag)
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
    
//    func checkLocationAuthorization() -> Bool {
//        switch locationManager.authorizationStatus {
//        case .denied, .restricted:
//            let alert = SesacAlertController(title: "위치 서비스 사용 불가", message: "서비스 사용을 위해 설청창으로 이동합니다.") {
//                if let bundleId = Bundle.main.bundleIdentifier,
//                   let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    self.dismiss(animated: false)
//                }
//            }
//            present(alert, animated: false)
//            return false
//        default:
//            return true
//        }
//    }
}

class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    static func registerKnownImplementations() {
        self.register { (locationManager) -> RxCLLocationManagerDelegateProxy in
            RxCLLocationManagerDelegateProxy(parentObject: locationManager, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: CLLocationManager) {
        object.delegate = delegate
    }
}

extension Reactive where Base: CLLocationManager {
    var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCLLocationManagerDelegateProxy.proxy(for: self.base)
    }
    
    var curAuthrizationState: Observable<CLAuthorizationStatus> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManagerDidChangeAuthorization(_:)))
            .map { parameters in
                guard let locationManager = parameters[0] as? CLLocationManager else {
                    return .denied
                }
                return locationManager.authorizationStatus
            }
    }
}
