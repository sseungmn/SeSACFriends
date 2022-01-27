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
    
    let authAPI: AuthAPI = AuthAPI()
    let firebaseAPI: Firebase = Firebase()
    
    struct Input {
        let submitButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let outputText: Observable<String>
        let buttonState: Observable<ButtonStyleState>
        let verifyResult: Observable<String>
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
        
        let buttonState: Observable<ButtonStyleState> = phoneNumber
            .map(validateNumber)
            .map { $0 ? .fill : .disable }
        
        let result = input.submitButtonTap
            .flatMap { [weak self] () -> Observable<Event<String>> in
                guard let self = self else { return Observable.just(.completed)}
                return self.firebaseAPI.verifyPhoneNumber()
                    .asObservable()
                    .materialize()
            }
            .share()
        
        result
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                AuthUserDefaults.phoneNumber = self.phoneNumber.value
            })
            .disposed(by: disposeBag)
        
        result.errors()
            .bind(to: errorCollector)
            .disposed(by: disposeBag)
        
        return Output(
            outputText: outputText,
            buttonState: buttonState,
            verifyResult: result.elements()
        )
    }
    
    func validateNumber(number: String) -> Bool {
        [12, 13].contains(number.count)
        && String(Array(number.decimalFilteredString)[...1]) == "01"
    }
}
