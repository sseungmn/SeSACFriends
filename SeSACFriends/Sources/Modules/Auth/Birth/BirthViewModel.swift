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
    
    let birth = BehaviorRelay<Date>(value: SesacUserDefaults.birth)
    let year = BehaviorRelay<Int>(value: 0)
    let month = BehaviorRelay<Int>(value: 0)
    let day = BehaviorRelay<Int>(value: 0)
    
    struct Input {
        let submitButtonTap: Driver<Void>
    }
    
    struct Output {
        let yearString: Driver<String>
        let monthString: Driver<String>
        let dayString: Driver<String>
        let yearFocus: Driver<Void>
        let monthFocus: Driver<Void>
        let dayFocus: Driver<Void>
        let buttonState: Driver<ButtonStyleState>
        let pushEmailViewController: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let birthDriver = birth.asDriver()
        let yearDriver = year.asDriver()
        let monthDriver = month.asDriver()
        let dayDriver = day.asDriver()
        
        birthDriver
            .compactMap { $0.component(for: .year) }
            .drive(year)
            .disposed(by: disposeBag)
        
        birthDriver
            .compactMap { $0.component(for: .month) }
            .drive(month)
            .disposed(by: disposeBag)
        
        birthDriver
            .compactMap { $0.component(for: .day) }
            .drive(day)
            .disposed(by: disposeBag)
            
        let buttonState: Driver<ButtonStyleState> = Driver
            .combineLatest(yearDriver, monthDriver, dayDriver)
            .map {  _ in .fill }
        
        let pushEmailViewController = input.submitButtonTap
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                SesacUserDefaults.birth = self.birth.value
            })
        
        return Output(
            yearString: yearDriver.map { String($0) },
            monthString: monthDriver.map { String($0) },
            dayString: dayDriver.map { String($0) },
            yearFocus: yearDriver.mapToVoid(),
            monthFocus: monthDriver.mapToVoid(),
            dayFocus: dayDriver.mapToVoid(),
            buttonState: buttonState,
            pushEmailViewController: pushEmailViewController
        )
    }
}
