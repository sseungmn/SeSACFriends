//
//  SesacMapView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/08.
//

import Foundation
import CoreLocation
import NMapsMap

extension CLLocationCoordinate2D {
    var NMGLatLng: NMGLatLng {
        return NMapsMap.NMGLatLng(lat: self.latitude, lng: self.longitude)
    }
}

class SesacMapView: NMFMapView {
    
    private static let baseCoordinate = NMGLatLng(lat: 37.517819364682694, lng: 126.88647317074734)
    private var zoomMaxScale: Double = 30
    
    var centerMarker = UIImageView().then { marker in
        marker.image = Asset.Assets.mapMarker.image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContraints() {
        addSubview(centerMarker)
        centerMarker.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func updateLocation(coordinate: NMGLatLng? = nil) {
        let coordinate = coordinate ?? SesacMapView.baseCoordinate
        moveCamera(NMFCameraUpdate(scrollTo: coordinate))
    }
}

extension SesacMapView {
    
    func setZoomLevel() {
        zoomMaxScale = projection.metersPerPixel(
            atLatitude: SesacMapView.baseCoordinate.lat,
            zoom: NMF_MAX_ZOOM
        )
        zoomLevel = calcZoomLevel(width: 1400, scale: zoomMaxScale)
        maxZoomLevel = calcZoomLevel(width: 100, scale: zoomMaxScale)
        minZoomLevel = calcZoomLevel(width: 6000, scale: zoomMaxScale)
    }
    
    private func calcZoomLevel(width: Double, scale: Double) -> Double {
        let deviceWidth = UIScreen.main.bounds.width
        return 22 - log2(width / (deviceWidth * scale))
    }
}
