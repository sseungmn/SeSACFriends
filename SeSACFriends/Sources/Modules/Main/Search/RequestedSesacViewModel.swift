//
//  RequestedSesacViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/16.
//

import Foundation
import RxSwift
import RxCocoa

class RequestedSesacViewModel: ViewModel, ViewModelType {
    struct Input {
        var viewWillAppearTrigger: Driver<Bool>
    }
    
    struct Output {
        var requestedSesacArray: Driver<[QueuedUser]>
        var showEmptyView: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let onqueue = input.viewWillAppearTrigger.asObservable()
            .flatMap { _ -> Observable<Event<Onqueue>> in
                let targetCoor = (lat: SesacUserDefaults.targetLatitude,
                                  lng: SesacUserDefaults.targetLongitude)
                return QueueAPI.shared.onqueue(
                    lat: targetCoor.lat,
                    long: targetCoor.lng
                )
                    .asObservable()
                    .retryWithTokenIfNeeded()
                    .materialize()
            }
            .share()
        
        let requestedSesacArray = onqueue.elements()
            .map { $0.fromQueueDBRequested }
            .share()
        
        let showEmptyView = requestedSesacArray
            .map { !$0.isEmpty }
        
        return Output(
            requestedSesacArray: requestedSesacArray.asDriverOnErrorJustComplete(),
            showEmptyView: showEmptyView.asDriverOnErrorJustComplete()
        )
    }
}
