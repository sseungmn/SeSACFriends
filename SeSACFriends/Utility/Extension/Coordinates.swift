//
//  Coordinates.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/15.
//

import Foundation
import CoreLocation
import NMapsMap

typealias Coordinates = (lat: Double, lng: Double)

extension NMGLatLng {
    var CLLocationCoordinate2D: CLLocationCoordinate2D {
        return CoreLocation.CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
    }
    var coordinates: Coordinates {
        return (lat: self.lat, lng: self.lng)
    }
}

extension CLLocationCoordinate2D {
    var NMGLatLng: NMGLatLng {
        return NMapsMap.NMGLatLng(lat: self.latitude, lng: self.longitude)
    }
    var coordinates: Coordinates {
        return (lat: self.latitude, lng: self.longitude)
    }
}
