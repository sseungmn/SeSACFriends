//
//  AuthCodeViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/23.
//

import Foundation

import FirebaseAuth
import RxSwift
import RxCocoa

class AuthCodeViewModel: ViewModel {
     
    var disposeBag: DisposeBag = DisposeBag()
    
    let authCode = PublishRelay<String>()
    
    let timeLimit = 60
    let setTimer = BehaviorRelay<Void>(value: ())
    
    let error = PublishRelay<AuthCodeError>()
    
    struct Input {
        let inputText: Observable<String>
        let resendButtonTap: Observable<Void>
        let submitButtonTap: Observable<Void>
        let viewDidLoad: Observable<Bool>
    }
    
    struct Output {
        let remainTime: Observable<Int>
        let buttonState: Observable<ButtonStyleState>
        let isUser: Observable<Bool>
        let error: Observable<AuthCodeError>
        let sentAuthCode: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        // Timer
        let remainTime = setTimer
            .flatMapLatest { Driver<Int>.timer(.seconds(0), period: .seconds(1)) }
            .map { self.timeLimit - $0 }
            .filter { $0 >= 0 }
            .share(replay: 1)
        
        // resend Authcode
        input.resendButtonTap
            .bind(to: setTimer)
            .disposed(by: disposeBag)
        
        let sendAuthCode = Observable
            .merge(
                input.resendButtonTap,
                input.viewDidLoad.filter { $0 }.map { _ in () }
            )
            .flatMap(Firebase.shared.verifyPhoneNumber)
            .map { _ in () }
            .debug()
        
        input.inputText
            .bind(to: authCode)
            .disposed(by: disposeBag)
        
        // Validation
        let buttonState: Observable<ButtonStyleState> = authCode
            .map(validate)
            .map { $0 ? .fill : .disable }
            
        // check deadline
        input.submitButtonTap
            .withLatestFrom(remainTime)
            .subscribe { [weak self] time in
                guard let time = time.element else { return }
                guard time > 0 else {
                    self?.error.accept(AuthCodeError.authCodeExpired)
                    return
                }
            }
            .disposed(by: disposeBag)
        
        // check isUser
        let idtoken: Observable<Bool> = input.submitButtonTap
            .withLatestFrom(remainTime)
            .filter { $0 > 0 }
            .withLatestFrom(authCode.asObservable())
            .flatMapLatest(Firebase.shared.credential)
            .map {
                switch $0 {
                case .failure(let error):
                    self.error.accept(error)
                    return false
                case .success:
                    return true
                }
            }
        
        let isUser = idtoken
            .filter { $0 }
            .map { _ in () }
            .flatMap(AuthAPI.shared.isUser)
            .debug()
        
        return Output(
            remainTime: remainTime,
            buttonState: buttonState,
            isUser: isUser,
            error: error.asObservable(),
            sentAuthCode: sendAuthCode
        )
    }
    
    func validate(authCode: String) -> Bool {
        authCode.count == 6
    }
}

enum AuthCodeError: Error {
    case authCodeExpired
    case idtokenError
    case invalidCode
}
enum APIError: Error {
    case firebaseTokenExpired, severError, clientError
    case undefinedError
}
