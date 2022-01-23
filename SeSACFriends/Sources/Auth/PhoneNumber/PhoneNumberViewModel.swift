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

class PhoneNumberViewModel: ViewModel {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let phoneNumber = PublishRelay<String>()
    
    struct Input {
        let inputText: Observable<String>
        let submitButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let outputText: Observable<String>
        let buttonState: Observable<ButtonStyleState>
        let verifyResult: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let outputText = input.inputText
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
        
        outputText
            .map { "+82 \($0)"}
            .bind(to: phoneNumber)
            .disposed(by: disposeBag)
        
        let buttonState: Observable<ButtonStyleState> = input.inputText
            .map(validateNumber)
            .map { $0 ? .fill : .disable }
        
        let result = input.submitButtonTap
            .withLatestFrom(phoneNumber.asObservable())
            .flatMap(Firebase.shared.verifyPhoneNumber)
            .observe(on: MainScheduler.instance)
        
        return Output(
            outputText: outputText,
            buttonState: buttonState,
            verifyResult: result
        )
    }
    
    func validateNumber(number: String) -> Bool {
        return [12, 13].contains(number.count)
                && String(Array(number.decimalFilteredString)[...1]) == "01"
    }
}
