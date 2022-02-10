//
//  EmailViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/24.
//

import UIKit
import RxSwift
import RxCocoa

class EmailViewModel: ViewModel, ViewModelType {
    
    let email = BehaviorRelay<String>(value: SesacUserDefaults.email)
    
    struct Input {
        let confirmButtonTap: Driver<Void>
    }
    
    struct Output {
        let buttonState: Driver<ButtonStyleState>
        let pushGenderViewController: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let isValidEmail = email
            .map(validate)
            .asDriver(onErrorJustReturn: false)
        
        let buttonState: Driver<ButtonStyleState> = isValidEmail
            .map { $0 ? .fill : .disable }
            .asDriver(onErrorJustReturn: .disable)
        
        let validEmail = input.confirmButtonTap
            .withLatestFrom(isValidEmail)
        
        validEmail
            .filter { !$0 }
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.errorCollector.accept(EmailError.invalidEmail)
            })
            .disposed(by: disposeBag)
        
        let pushGenderViewController = validEmail
            .filter { $0 }.mapToVoid()
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                SesacUserDefaults.email = self.email.value
            })
            .asDriver()
        
        return Output(
            buttonState: buttonState,
            pushGenderViewController: pushGenderViewController
        )
    }
    
    func validate(email: String) -> Bool {
        let components = email.components(separatedBy: ["@", "."])
            .filter { $0.count > 0 }
        return components.count == 3
    }
}

enum EmailError: Error {
    case invalidEmail
}
