//
//  MarkerManager.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/09.
//

import Foundation
import NMapsMap

extension Int {
    var sesacCharacter: SesacCharacter {
        switch self {
        case 1: return .strong
        case 2: return .mint
        case 3: return .purple
        case 4: return .gold
        default: return .basic
        }
    }
}

class MarkerManager {
    static let shared = MarkerManager()
    private init() {}
    
    private let basicSesacIconImage = NMFOverlayImage(image: SesacCharacter.basic.image)
    private let strongSesacIconImage = NMFOverlayImage(image: SesacCharacter.strong.image)
    private let mintSesacIconImage = NMFOverlayImage(image: SesacCharacter.mint.image)
    private let purpleSesacIconImage = NMFOverlayImage(image: SesacCharacter.purple.image)
    private let goldSesacIconImage = NMFOverlayImage(image: SesacCharacter.gold.image)
    
    var mapView: NMFMapView!
    
    var markers = Set<NMFMarker>() {
        didSet {
            markers.forEach { marker in
                marker.mapView = mapView
                marker.width = 80
                marker.height = 80
            }
        }
    }
    
    func clearMarkers() {
        markers.forEach { marker in
            marker.mapView = nil
        }
    }
    
    func markerImage(sesacCharacter: SesacCharacter) -> NMFOverlayImage {
        switch sesacCharacter {
        case .basic:
            return basicSesacIconImage
        case .strong:
            return strongSesacIconImage
        case .mint:
            return mintSesacIconImage
        case .purple:
            return purpleSesacIconImage
        case .gold:
            return goldSesacIconImage
        }
    }
}
