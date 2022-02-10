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
    
    let gender = BehaviorRelay<Gender>(value: SesacUserDefaults.gender.toGender)
    let hobby = BehaviorRelay<String>(value: "")
    let searchable = BehaviorRelay<Bool>(value: false)
    let ageRange = BehaviorRelay<[CGFloat]>(value: [18, 35])
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let saveButtonTap: Driver<Void>
        let womanOptionButtonTap: Driver<Void>
        let manOptionButtonTap: Driver<Void>
        let withdrawButtonTap: Driver<Void>
        let rangeValues: Driver<[CGFloat]>
    }
    
    struct Output {
        let gender: Driver<Gender>
        let ageLabelText: Driver<String>
        let withdrawCompleted: Driver<Void>
        let saveCompleted: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let user = input.viewWillAppear
            .filter { $0 }
            .flatMapLatest { _ -> Observable<Event<User>> in
                return AuthAPI.shared.getUser()
                    .asObservable()
                    .retryWithTokenIfNeeded()
                    .materialize()
            }
            .share()
        
        user.elements()
            .withUnretained(self)
            .bind { (owner, user) in
                owner.gender.accept(user.gender.toGender)
                owner.hobby.accept(user.hobby)
                owner.searchable.accept(
                    Bool(truncating: user.searchable as NSNumber)
                )
                owner.ageRange.accept([CGFloat(user.ageMin), CGFloat(user.ageMax)]
                )
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
            .share()
        
        updateUser.errors()
            .bind(to: errorCollector)
            .disposed(by: disposeBag)
        
        input.womanOptionButtonTap
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.gender.accept(.woman)
            }
            .disposed(by: disposeBag)
        
        input.manOptionButtonTap
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.gender.accept(.man)
            }
            .disposed(by: disposeBag)
        
        let ageLabelText = ageRange
            .map { ageRange in
                "\(Int(ageRange[0])) - \(Int(ageRange[1]))"
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
            gender: gender.asDriver(),
            ageLabelText: ageLabelText.asDriverOnErrorJustComplete(),
            withdrawCompleted: withdraw.elements().asDriverOnErrorJustComplete(),
            saveCompleted: updateUser.elements().asDriverOnErrorJustComplete()
        )
    }
}
