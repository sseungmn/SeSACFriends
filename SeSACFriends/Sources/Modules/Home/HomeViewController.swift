//
//  HomeViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/05.
//

import UIKit
import NMapsMap
import RxSwift
import RxRelay
import RxCocoa

class HomeViewController: ViewController {
    
    let mainView = HomeView()
    
    private let SesacBaseCoor = NMGLatLng(lat: 37.517819364682694, lng: 126.88647317074734)
    
    override func loadView() {
        view = mainView
    }
    
    override func configure() {
        let cameraUpdate = NMFCameraUpdate(scrollTo: SesacBaseCoor)
        mainView.mapView.moveCamera(cameraUpdate)
    }
}
