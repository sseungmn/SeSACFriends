//
//  NearSearchViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/15.
//

import Foundation
import RxSwift
import RxCocoa

class NearSesacViewModel: ViewModel, ViewModelType {
    struct Input {
        var viewWillAppearTrigger: Driver<Bool>
    }
    
    struct Output {
        var nearSesacArray: Driver<[QueuedUser]>
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
        
        let nearSesacArray = onqueue.elements()
            .map { $0.fromQueueDB }
            
        return Output(
            nearSesacArray: nearSesacArray.asDriverOnErrorJustComplete()
        )
    }
}
