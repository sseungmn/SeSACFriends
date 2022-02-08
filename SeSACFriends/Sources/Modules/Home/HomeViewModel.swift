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
    
    struct Input {
        var curCoordinates: Observable<NMGLatLng>
        var mapViewIdleState: Observable<Void>
    }
    
    struct Output {
        var onqueueResponse: Observable<Onqueue>
    }
    
    func transform(input: Input) -> Output {
        
        let onqueue = input.mapViewIdleState
            .withLatestFrom(input.curCoordinates)
            .flatMap { coordinates in
                QueueAPI.shared.onqueue(lat: coordinates.lat, long: coordinates.lng)
                    .asObservable()
                    .retryWithTokenIfNeeded()
                    .materialize()
            }
            .share()
        
        onqueue.errors()
            .bind(to: errorCollector)
            .disposed(by: disposeBag)
        
        return Output(
            onqueueResponse: onqueue.elements()
        )
    }
}
