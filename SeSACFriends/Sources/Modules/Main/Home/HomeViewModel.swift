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
        var curCoordinates: Driver<NMGLatLng>
        var viewWillAppear: Driver<Bool>
        var gpsButtonTrigger: Observable<Void>
        var mapViewIdleTrigger: Driver<Void>
        var filteredGender: Driver<Gender>
        var curAuthorizationState: Driver<CLAuthorizationStatus>
        var matchingStatusButtonTrigger: Driver<Void>
    }
    
    struct Output {
        var fetchInfo: Driver<User>
        var queuedUsers: Driver<[QueuedUser]>
        var requestLocationAuthorization: Signal<Void>
        var updateCameraToCurrentLocation: Driver<Void>
        var isUserInteractionEnabledMap: Signal<Bool>
        var needGenderSelection: Driver<Void>
        var pushHobbyScene: Driver<NMGLatLng>
        var pushSearchScene: Driver<Void>
        var pushChattingScene: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let info = input.viewWillAppear.asObservable().debug()
            .flatMap { _ in
                AuthAPI.shared.getUser()
                    .asObservable()
                    .retryWithTokenIfNeeded()
                    .materialize()
            }
        
        info.errors()
            .bind(to: errorCollector)
            .disposed(by: disposeBag)
        
        input.mapViewIdleTrigger.asObservable()
            .bind { [weak self] _ in
                self?.isUserInteractionEnabledMap.accept(false)
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.8) {
                    self?.isUserInteractionEnabledMap.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: Onqueue
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
        
        let onqueue = Observable.merge(
            input.mapViewIdleTrigger.asObservable(),
            input.filteredGender.mapToVoid().asObservable(),
            updateCameraToCurLocation,
            locationDidAuthorized.mapToVoid().asObservable(),
            input.viewWillAppear.mapToVoid().asObservable()
        )
            .withLatestFrom(input.curCoordinates)
            .flatMap { coor in
                QueueAPI.shared.onqueue(lat: coor.lat, long: coor.lng)
                    .map { $0.fromQueueDB }
                    .asObservable()
                    .retryWithTokenIfNeeded()
                    .materialize()
            }
            .share()
        
        onqueue.errors()
            .bind(to: errorCollector)
            .disposed(by: disposeBag)
        
        onqueue.elements()
            .bind(to: queuedUsers)
            .disposed(by: disposeBag)
        
        let filteredQueuedUsers = Observable.combineLatest(
            queuedUsers.asObservable(),
            input.filteredGender.asObservable()
        ) { (queuedUsers, filteredGender) -> [QueuedUser] in
            return queuedUsers.filter { user in
                switch filteredGender {
                case .unknown:
                    return true
                default:
                    return user.gender == filteredGender.rawValue
                }
            }
        }
        
        // MARK: Matching Status
        let matchingStatus = input.matchingStatusButtonTrigger
            .withLatestFrom(input.curAuthorizationState)
            .filter { [weak self] state in
                switch state {
                case .restricted, .denied:
                    self?.requestLocationAuthorization.accept(())
                    return false
                default: return true
                }
            }
            .mapToVoid()
        
        let defaultStatus = matchingStatus
            .filter { SesacUserDefaults.matchingStatus == .default }
            
        let pushHobbyScene = defaultStatus
            .filter { SesacUserDefaults.gender != -1 }
            .withLatestFrom(input.curCoordinates)
        
        let needGenderSelection = defaultStatus
            .filter { SesacUserDefaults.gender == -1 }
            .mapToVoid()
        
        let pushSerachScene = matchingStatus
            .filter { SesacUserDefaults.matchingStatus == .waiting }
            .mapToVoid()
        
        let pushChattingScene = matchingStatus
            .filter { SesacUserDefaults.matchingStatus == .matched }
            .mapToVoid()
        
        return Output(
            fetchInfo: info.elements().asDriverOnErrorJustComplete(),
            queuedUsers: filteredQueuedUsers.asDriverOnErrorJustComplete(),
            requestLocationAuthorization: requestLocationAuthorization.debug().asSignal(onErrorJustReturn: ()),
            updateCameraToCurrentLocation: updateCameraToCurLocation.asDriverOnErrorJustComplete(),
            isUserInteractionEnabledMap: isUserInteractionEnabledMap.asSignal(),
            needGenderSelection: needGenderSelection,
            pushHobbyScene: pushHobbyScene,
            pushSearchScene: pushSerachScene,
            pushChattingScene: pushChattingScene
        )
    }
}
