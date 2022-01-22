//
//  PhoneNumberViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/22.
//

import Foundation

import FirebaseAuth
import RxSwift
import RxCocoa

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}

enum VerificationError: Error {
    case fail
}

class PhoneNumberViewModel: ViewModel {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let phoneNumber = PublishRelay<String>()
    
    struct Input {
        let inputText: Observable<String>
        let buttonTap: ControlEvent<Void>
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
        
        let result = input.buttonTap
            .withLatestFrom(phoneNumber.asObservable())
            .flatMap(verifyPhoneNumber)
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
    
    func verifyPhoneNumber(phoneNumber: String) -> Observable<String> {
        print("DEBUG || phoneNumber :", phoneNumber)
        return Observable<String>.create { observer in
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    guard let verificationID = verificationID else {
                        observer.onError(VerificationError.fail)
                        return
                    }
                    observer.onNext(verificationID)
                }
            return Disposables.create()
        }
    }
}
