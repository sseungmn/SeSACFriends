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

class AuthCodeViewModel: ViewModel, ViewModelType {
     
    let authCode = BehaviorRelay<String>(value: "")
    
    let timeLimit = 60
    let setTimer = BehaviorRelay<Void>(value: ())
    
    struct Input {
        let resendButtonTap: Observable<Void>
        let submitButtonTap: Observable<Void>
        let viewDidLoad: Observable<Bool>
    }
    
    struct Output {
        let remainTime: Observable<Int>
        let buttonState: Observable<ButtonStyleState>
        let sentAuthCode: Observable<String>
        let makeRootMainViewController: Observable<Void>
        let pushNicknameViewControoler: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        // Timer
        let remainTime = setTimer
            .flatMapLatest { Driver<Int>.timer(.seconds(0), period: .seconds(1)) }
            .map { self.timeLimit - $0 }
            .filter { $0 >= 0 }
            .share()
        
        // resend Authcode
        input.resendButtonTap
            .bind(to: setTimer)
            .disposed(by: disposeBag)
        
        let sendAuthCode = Observable
            .merge(
                input.resendButtonTap,
                input.viewDidLoad.filter { $0 }.mapToVoid()
            )
            .flatMap { () -> Observable<Event<String>> in
                return Firebase.shared.verifyPhoneNumber()
                    .asObservable()
                    .materialize()
            }
        
        sendAuthCode.errors()
            .bind(to: errorCollector)
            .disposed(by: disposeBag)
        
        // Validation
        let buttonState: Observable<ButtonStyleState> = authCode
            .map(validate)
            .map { $0 ? .fill : .disable }
            
        // check deadline
        input.submitButtonTap
            .withLatestFrom(remainTime)
            .filter { $0 <= 0 }
            .subscribe(onNext: { [weak errorCollector] _ in
                errorCollector?.accept(AuthCodeError.authCodeExpired)
            })
            .disposed(by: disposeBag)
        
        // get idtoken
        let idtoken = input.submitButtonTap
            .withLatestFrom(remainTime)
            .filter { $0 > 0 }
            .withLatestFrom(authCode.asObservable())
            .flatMapLatest { authCode -> Observable<Event<Void>> in
                return Firebase.shared.credential(verificationCode: authCode)
                    .asObservable()
                    .materialize()
            }
            .share()
        idtoken.errors()
            .bind(to: self.errorCollector)
            .disposed(by: disposeBag)
        
        // check isUser
        let isUser = idtoken.elements()
            .flatMapLatest { () -> Observable<Event<Bool>> in
                return AuthAPI.shared.isUser()
                    .asObservable()
                    .materialize()
            }
            .share()
        isUser.errors()
            .bind(to: self.errorCollector)
            .disposed(by: disposeBag)
        
        let makeRootMainViewController = isUser.elements()
            .filter { $0 == true }
            .mapToVoid()
            .observe(on: MainScheduler.instance)
        
        let pushNicknameViewControoler = isUser.elements()
            .filter { $0 == false }
            .mapToVoid()
            .observe(on: MainScheduler.instance)
        
        return Output(
            remainTime: remainTime,
            buttonState: buttonState,
            sentAuthCode: sendAuthCode.elements(),
            makeRootMainViewController: makeRootMainViewController,
            pushNicknameViewControoler: pushNicknameViewControoler
        )
    }
    
    func validate(authCode: String) -> Bool {
        authCode.count == 6
    }
}
