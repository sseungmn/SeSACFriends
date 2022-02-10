//
//  HomeViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/08.
//

import Foundation
import NMapsMap
import RxSwift
import RxCocoa

class HomeViewModel: ViewModel, ViewModelType {
    
    let queuedUsers = BehaviorRelay<[QueuedUser]>(value: [])
    let requestLocationAuthorization = PublishRelay<Void>()
    let isUserInteractionEnabledMap = PublishRelay<Bool>()
    
    struct Input {
        var curCoordinates: Observable<NMGLatLng>
        var viewWillAppear: Observable<Bool>
        var gpsButtonTrigger: Observable<Void>
        var mapViewIdleTrigger: Driver<Void>
        var filteredGender: Observable<Gender>
        var curAuthorizationState: Driver<CLAuthorizationStatus>
    }
    
    struct Output {
        var queuedUsers: Driver<[QueuedUser]>
        var requestLocationAuthorization: Signal<Void>
        var updateCameraToCurrentLocation: Driver<Void>
        var isUserInteractionEnabledMap: Signal<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let onqueue = input.mapViewIdleTrigger.asObservable()
            .withLatestFrom(input.curCoordinates)
            .flatMap { coordinates in
                QueueAPI.shared.onqueue(lat: coordinates.lat, long: coordinates.lng)
                    .map { $0.fromQueueDB }
                    .asObservable()
                    .retryWithTokenIfNeeded()
                    .materialize()
            }
            .share()
        
        input.mapViewIdleTrigger.asObservable()
            .bind { [weak self] _ in
                self?.isUserInteractionEnabledMap.accept(false)
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.8) {
                    self?.isUserInteractionEnabledMap.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        onqueue.errors()
            .bind(to: errorCollector)
            .disposed(by: disposeBag)
        
        onqueue.elements()
            .bind(to: queuedUsers)
            .disposed(by: disposeBag)
        
        let locationDidAuthorized = input.curAuthorizationState
            .filter { [weak self] state in
                switch state {
                case .restricted, .denied:
                    self?.requestLocationAuthorization.accept(())
                    return false
                default: return true
                }
            }
        
        let updateCameraToCurLocation = input.gpsButtonTrigger
            .withLatestFrom(locationDidAuthorized)
            .mapToVoid()
        
        let filteredQueuedUsers = Observable.combineLatest(
                input.filteredGender,
                queuedUsers.asObservable(),
                updateCameraToCurLocation,
                locationDidAuthorized.asObservable(),
                input.viewWillAppear
            ) { (filteredGender, queuedUsers, _, _, _) -> [QueuedUser] in
                return queuedUsers.filter { user in
                    switch filteredGender {
                    case .unknown:
                        return true
                    default:
                        return user.gender == filteredGender.rawValue
                    }
                }
            }
        
        return Output(
            queuedUsers: filteredQueuedUsers.asDriverOnErrorJustComplete(),
            requestLocationAuthorization: requestLocationAuthorization.debug().asSignal(onErrorJustReturn: ()),
            updateCameraToCurrentLocation: updateCameraToCurLocation.asDriverOnErrorJustComplete(),
            isUserInteractionEnabledMap: isUserInteractionEnabledMap.asSignal()
        )
    }
}
