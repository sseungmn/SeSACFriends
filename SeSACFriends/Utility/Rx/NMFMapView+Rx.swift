//
//  Rx+NMFMapView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/09.
//

import Foundation
import NMapsMap
import RxSwift
import RxCocoa

class RxNMFMapViewDelegateProxy: DelegateProxy<NMFMapView, NMFMapViewDelegate>, DelegateProxyType, NMFMapViewDelegate {
    
    static func registerKnownImplementations() {
        self.register { (mapView) -> RxNMFMapViewDelegateProxy in
            RxNMFMapViewDelegateProxy(parentObject: mapView, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: NMFMapView) -> NMFMapViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: NMFMapViewDelegate?, to object: NMFMapView) {
        object.delegate = delegate
    }
}

extension Reactive where Base: NMFMapView {
    var delegate: DelegateProxy<NMFMapView, NMFMapViewDelegate> {
        return RxNMFMapViewDelegateProxy.proxy(for: self.base)
    }
    
    var curCoordinates: Observable<NMGLatLng> {
        return delegate.methodInvoked(#selector(NMFMapViewDelegate.mapViewIdle(_:)))
            .map { parameters in
                guard let mapView = parameters[0] as? NMFMapView else {
                    return NMGLatLng(lat: 0, lng: 0)
                }
                return NMGLatLng(lat: mapView.latitude, lng: mapView.longitude)
            }
    }
    
    var mapViewIdleState: Observable<Void> {
        return delegate.methodInvoked(#selector(NMFMapViewDelegate.mapViewIdle(_:)))
            .mapToVoid()
    }
}
