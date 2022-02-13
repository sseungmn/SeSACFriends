//
//  HobbyViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/13.
//

import Foundation
import NMapsMap
import RxSwift
import RxCocoa

class HobbyViewModel: ViewModel, ViewModelType {
    
    var curCoordinates: Observable<NMGLatLng>!
    let recommendedHobby = BehaviorRelay<[String]>(value: [])
    let queuedUsersHobby = BehaviorRelay<[String]>(value: [])
    let myHobby = BehaviorRelay<[String]>(value: [])
    
    init(curCoordinates: NMGLatLng) {
        super.init()
        self.curCoordinates = Observable.just(curCoordinates)
    }
    
    struct Input {
        var viewWillAppear: Driver<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        let onqueue = input.viewWillAppear.asObservable()
            .withLatestFrom(curCoordinates)
            .flatMap { coor in
                QueueAPI.shared.onqueue(lat: coor.lat, long: coor.lng)
                    .asObservable()
                    .retryWithTokenIfNeeded()
                    .materialize()
            }
            .share()
        
        onqueue.errors()
            .bind(to: errorCollector)
            .disposed(by: disposeBag)
        
        onqueue.elements()
            .subscribe(onNext: { [weak self] onqueue in
                self?.recommendedHobby.accept(onqueue.fromRecommend)
                var hobbyArray: [String] = []
                onqueue.fromQueueDB.forEach { queuedUser in
                    hobbyArray.append(contentsOf: queuedUser.hf)
                }
                onqueue.fromQueueDBRequested.forEach { queuedUser in
                    hobbyArray.append(contentsOf: queuedUser.hf)
                }
                self?.queuedUsersHobby.accept(hobbyArray)
            })
            .disposed(by: disposeBag)
        
        return Output(
            
        )
    }
}
