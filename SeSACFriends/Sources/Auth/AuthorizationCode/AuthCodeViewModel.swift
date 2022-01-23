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
import RxAlamofire

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
        let viewWillDisappear: Observable<Bool>
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
            .take(until: input.viewWillDisappear)
            .share(replay: 1, scope: .whileConnected)
        
        // resend Authcode
        input.resendButtonTap
            .bind(to: setTimer)
            .disposed(by: disposeBag)
        
        let sendAuthCode = input.resendButtonTap
            .withLatestFrom(input.viewDidLoad.filter { $0 }.map { _ in () }.asObservable())
            .flatMap(Firebase.shared.verifyPhoneNumber)
            .map { _ in () }
            .asObservable()
            .debug()
        
        input.inputText
            .bind(to: authCode)
            .disposed(by: disposeBag)
        
        // Validation
        let buttonState: Observable<ButtonStyleState> = authCode
            .map { $0.count == 6 }
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
        let idToken = input.submitButtonTap
            .withLatestFrom(remainTime)
            .filter { $0 > 0 }
            .withLatestFrom(authCode.asObservable())
            .flatMap(Firebase.shared.credential)
            .asDriver(onErrorRecover: { error in
                if let error = error as? AuthCodeError {
                    self.error.accept(error)
                }
                return Driver.just(nil)
            })
            .asObservable()
        
        let isUser = idToken
            .compactMap { $0 }
            .flatMap(AuthAPI.shared.isUser)
        
        return Output(
            remainTime: remainTime,
            buttonState: buttonState,
            isUser: isUser,
            error: error.asObservable(),
            sentAuthCode: sendAuthCode
        )
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
