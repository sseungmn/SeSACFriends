//
//  EmailViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/24.
//

import UIKit

import RxSwift
import RxCocoa

class EmailViewModel: ViewModel {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let email = BehaviorRelay<String>(value: "")
    let error = PublishRelay<EmailError>()
    
    struct Input {
        let inputText: Driver<String>
        let confirmButtonTap: Driver<Void>
    }
    
    struct Output {
        let buttonState: Driver<ButtonStyleState>
        let confirmButtonTap: Driver<Bool>
        let error: Signal<EmailError>
    }
    
    func transform(input: Input) -> Output {
        input.inputText
            .drive(email)
            .disposed(by: disposeBag)
        
        let isValidEmail: Driver<Bool> = email
            .map(validate)
            .asDriver(onErrorJustReturn: false)
        
        let buttonState: Driver<ButtonStyleState> = isValidEmail
            .map { $0 ? .fill : .disable }
        
        let confirmButtonTap = input.confirmButtonTap
            .withLatestFrom(isValidEmail)
            .map { isValid -> Bool in
                if !isValid { self.error.accept(.invalidEmail) }
                return isValid
            }
            
        return Output(
            buttonState: buttonState,
            confirmButtonTap: confirmButtonTap,
            error: error.asSignal()
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
