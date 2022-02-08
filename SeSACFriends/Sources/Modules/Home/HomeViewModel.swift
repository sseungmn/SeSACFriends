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
    
    struct Input {
        var curCoordinates: Observable<NMGLatLng>
        var mapViewIdleState: Observable<Void>
        var filteredGender: Observable<Gender>
    }
    
    struct Output {
        var queuedUsers: Driver<[QueuedUser]>
    }
    
    func transform(input: Input) -> Output {
        
        let onqueue = input.mapViewIdleState
            .withLatestFrom(input.curCoordinates)
            .flatMap { coordinates in
                QueueAPI.shared.onqueue(lat: coordinates.lat, long: coordinates.lng)
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
        
        let filteredQueuedUsers = Observable.combineLatest(input.filteredGender, queuedUsers.asObservable()) { (filteredGender, queuedUsers) -> [QueuedUser] in
            return queuedUsers.filter { user in
                switch filteredGender {
                case .unknown:
                    return true
                default:
                    return user.gender == filteredGender.rawValue
                }
            }
        }
            .asDriverOnErrorJustComplete()
        
        return Output(
            queuedUsers: filteredQueuedUsers
        )
    }
}
