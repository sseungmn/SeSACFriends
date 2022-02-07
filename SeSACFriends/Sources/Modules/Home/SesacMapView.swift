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
    var centerMarker = NMFMarker().then { marker in
        marker.position = SesacMapView.baseCoordinate
        marker.iconImage = NMFOverlayImage(image: Asset.Assets.mapMarker.image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        zoomLevel = 12
        centerMarker.mapView = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLocation(coordinate: NMGLatLng = SesacMapView.baseCoordinate) {
        moveCamera(NMFCameraUpdate(scrollTo: coordinate))
        centerMarker.position = coordinate
    }
}
