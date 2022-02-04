//
//  SettingMyInfoViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/03.
//

import UIKit
import RxSwift
import RxCocoa

class SettingMyInfoViewModel: ViewModel, ViewModelType {
    
    let gender = BehaviorRelay<Gender>(value: .unknown)
    let hobby = BehaviorRelay<String>(value: "")
    let searchable = BehaviorRelay<Bool>(value: false)
    let ageRange = BehaviorRelay<[CGFloat]>(value: [18, 35])
    
    struct Input {
        let viewDidLoad: Driver<Bool>
        let saveButtonTap: Driver<Void>
        let womanOptionButtonTap: Driver<Void>
        let manOptionButtonTap: Driver<Void>
        let withdrawButtonTap: Driver<Void>
        let rangeValues: Driver<[CGFloat]>
    }
    
    struct Output {
        let user: Driver<User>
        let gender: Driver<Gender>
        let ageLabelText: Driver<String>
        let doneWithdraw: Driver<Void>
        let saveCompleted: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let user = input.viewDidLoad.asObservable()
            .filter { $0 }
            .flatMapLatest { _ -> Observable<Event<User>> in
                return AuthAPI.shared.getUser()
                    .asObservable()
                    .retryWithTokenIfNeeded()
                    .materialize()
            }
            .debug()
            .share()
        
        user.elements()
            .withUnretained(self)
            .bind { (owner, user) in
                owner.gender.accept(user.gender.toGender)
            }
            .disposed(by: disposeBag)
        
        user.errors()
            .bind(to: errorCollector)
            .disposed(by: disposeBag)
        
        let updateUser = input.saveButtonTap.asObservable()
            .withLatestFrom(
                Observable.combineLatest(gender, hobby, searchable, ageRange)
            )
            .flatMapLatest { (gender, hobby, searchable, ageRange) -> Observable<Event<Void>> in
                let gender = gender.rawValue
                let searchable = searchable ? 1 : 0
                let ageMin = Int(ageRange[0])
                let ageMax = Int(ageRange[1])
                return AuthAPI.shared.updateUser(gender: gender, hobby: hobby, searchable: searchable, ageMin: ageMin, ageMax: ageMax)
                    .asObservable()
                    .retryWithTokenIfNeeded()
                    .materialize()
            }
        
        updateUser.errors()
            .bind(to: errorCollector)
            .disposed(by: disposeBag)
        
        input.womanOptionButtonTap.debug()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.gender.accept(.woman)
            }
            .disposed(by: disposeBag)
        
        input.manOptionButtonTap.debug()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.gender.accept(.man)
            }
            .disposed(by: disposeBag)
        
        let ageLabelText = ageRange
            .map { ageRange in
                "\(ageRange[0]) - \(ageRange[1])"
            }
        
        let withdraw = input.withdrawButtonTap.asObservable()
            .flatMapLatest { () -> Observable<Event<Void>> in
                return AuthAPI.shared.withDraw()
                    .asObservable()
                    .retryWithTokenIfNeeded()
                    .materialize()
            }
            .share()
        
        withdraw.errors()
            .bind(to: errorCollector)
            .disposed(by: disposeBag)
        
        return Output(
            user: user.elements().asDriverOnErrorJustComplete(),
            gender: gender.asDriver(),
            ageLabelText: ageLabelText.asDriverOnErrorJustComplete(),
            doneWithdraw: withdraw.elements().asDriverOnErrorJustComplete(),
            saveCompleted: updateUser.elements().asDriverOnErrorJustComplete()
        )
    }
}
