//
//  HomeViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/05.
//

import UIKit
import CoreLocation
import NMapsMap
import RxNMapsMap
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
//        self.mainView.mapView.updateLocation(coordinate: locationManager.location?.coordinate.NMGLatLng)
        self.mainView.mapView.updateLocation()
        self.mainView.mapView.setZoomLevel()
    }
    
    override func bind() {
        let input = HomeViewModel.Input(
            curCoordinates: mainView.mapView.rx.currentCoordinates.asDriverOnErrorJustComplete(),
            viewWillAppear: rx.viewWillAppear.asDriver(),
            gpsButtonTrigger: mainView.gpsButton.rx.tap.asObservable(),
            mapViewIdleTrigger: mainView.mapView.rx.mapViewIdle.asDriver().mapToVoid(),
            filteredGender: mainView.genderFilterView.filteredGender.asDriver(),
            curAuthorizationState: locationManager.rx.curAuthrizationState.asDriverOnErrorJustComplete(),
            matchingStatusButtonTrigger: mainView.matchingStatusButton.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)
        
        output.fetchInfo
            .drive(onNext: { user in
                SesacUserDefaults.nick = user.nick
                SesacUserDefaults.gender = user.gender
            })
            .disposed(by: disposeBag)
        
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
                let alert = SesacAlertController(title: "?????? ????????? ?????? ??????", message: "????????? ????????? ?????? ??????????????? ???????????????.") {
                    if let bundleId = Bundle.main.bundleIdentifier,
                       let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        self?.dismiss(animated: false)
                    }
                }
                self?.present(alert, animated: false)
            }
            .disposed(by: disposeBag)
        
        output.needGenderSelection
            .drive { [weak self] _ in
                self?.tabBarController?.selectedIndex = 2
                guard let nav = self?.tabBarController?.selectedViewController as? UINavigationController else {
                    return
                }
                let targetViewController = SettingMyInfoViewController()
                targetViewController.hidesBottomBarWhenPushed = true
                targetViewController.view.makeToast("?????? ?????? ????????? ???????????? ???????????? ????????? ????????????!")
                nav.pushViewController(targetViewController, animated: false)
            }
            .disposed(by: disposeBag)
        
        output.pushHobbyScene
            .drive { [weak self] curCoordinates in
                SesacUserDefaults.targetLatitude = curCoordinates.lat
                SesacUserDefaults.targetLongitude = curCoordinates.lng
                self?.push(viewController: HobbyViewController())
            }
            .disposed(by: disposeBag)
        
        output.pushSearchScene
            .drive { [weak self] _ in
                self?.push(viewController: SearchTabmanController())
            }
            .disposed(by: disposeBag)
        
        output.pushChattingScene
            .drive { [weak self] _ in
                self?.push(viewController: ChattingViewController())
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
