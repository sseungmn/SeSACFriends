//
//  PhoneNumberViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/22.
//

import Foundation
import RxSwift
import RxCocoa

enum VerificationError: Error {
    case fail
}

class PhoneNumberViewModel: ViewModel, ViewModelType {
    
    let phoneNumber = BehaviorRelay<String>(value: AuthUserDefaults.phoneNumber)
    
    struct Input {
        let submitButtonTap: Driver<Void>
    }
    
    struct Output {
        let outputText: Driver<String>
        let buttonState: Driver<ButtonStyleState>
        let verifyResult: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let outputText = phoneNumber
            .map { text -> String in
                switch text.count {
                case ...12:
                    return text.formated(by: "###-###-####")
                case 13:
                    return text.formated(by: "###-####-####")
                default:
                    return String(Array(text)[..<13])
                }
            }
            .asDriver(onErrorJustReturn: "")
        
        let buttonState: Driver<ButtonStyleState> = phoneNumber
            .map(validateNumber)
            .map { $0 ? .fill : .disable }
            .asDriver(onErrorJustReturn: .disable)
        
        let result = input.submitButtonTap.asObservable()
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                AuthUserDefaults.phoneNumber = self.phoneNumber.value
            })
            .flatMap { () -> Observable<Event<String>> in
                return Firebase.shared.verifyPhoneNumber()
                    .asObservable()
                    .materialize()
            }
            .share()
        
        result.errors()
            .do(onNext: { _ in
                AuthUserDefaults.phoneNumber = ""
            })
            .bind(to: errorCollector)
            .disposed(by: disposeBag)
        
        return Output(
            outputText: outputText,
            buttonState: buttonState,
            verifyResult: result.elements()
                .asDriver(onErrorJustReturn: "")
        )
    }
    
    func validateNumber(number: String) -> Bool {
        [12, 13].contains(number.count)
        && String(Array(number.decimalFilteredString)[...1]) == "01"
    }
}
