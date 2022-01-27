//
//  BirthViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/24.
//

import UIKit

import RxSwift
import RxCocoa

class BirthViewModel: ViewModel, ViewModelType {
    
    let birth = BehaviorRelay<Date>(value: AuthUserDefaults.birth)
    let year = PublishRelay<Int?>()
    let month = PublishRelay<Int?>()
    let day = PublishRelay<Int?>()
    
    struct Input {
        let submitButtonTap: Observable<Void>
    }
    
    struct Output {
        let yearString: Driver<String>
        let monthString: Driver<String>
        let dayString: Driver<String>
        let yearFocus: Driver<Void>
        let monthFocus: Driver<Void>
        let dayFocus: Driver<Void>
        let buttonState: Driver<ButtonStyleState>
        let pushEmailViewController: Signal<Void>
    }
    
    func transform(input: Input) -> Output {
        let birthObservable = birth.share()
        
        birthObservable
            .map { $0.component(for: .year) }
            .bind(to: year)
            .disposed(by: disposeBag)
        
        birthObservable
            .map { $0.component(for: .month) }
            .bind(to: month)
            .disposed(by: disposeBag)
        
        birthObservable
            .map { $0.component(for: .day) }
            .bind(to: day)
            .disposed(by: disposeBag)
            
        let yearDriver = year
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .distinctUntilChanged()
        
        let monthDriver = month
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .distinctUntilChanged()
        
        let dayDriver = day
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .distinctUntilChanged()
        
        let buttonState: Driver<ButtonStyleState> = Driver
            .combineLatest(yearDriver, monthDriver, dayDriver)
            .map {  _ in .fill }
        
        input.submitButtonTap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                AuthUserDefaults.birth = self.birth.value
            })
            .disposed(by: disposeBag)
        
        return Output(
            yearString: yearDriver.map { String($0) },
            monthString: monthDriver.map { String($0) },
            dayString: dayDriver.map { String($0) },
            yearFocus: yearDriver.mapToVoid(),
            monthFocus: monthDriver.mapToVoid(),
            dayFocus: dayDriver.mapToVoid(),
            buttonState: buttonState,
            pushEmailViewController: input.submitButtonTap.asSignal(onErrorJustReturn: ())
        )
    }
}
