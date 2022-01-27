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
    
    let authCode = BehaviorRelay<String>(value: "")
    
    let timeLimit = 60
    let setTimer = BehaviorRelay<Void>(value: ())
    
    let error = PublishRelay<Error>()
    
    let firebaseAPI: Firebase = Firebase()
    let authAPI: AuthAPI = AuthAPI()
    
    struct Input {
        let resendButtonTap: Observable<Void>
        let submitButtonTap: Observable<Void>
        let viewDidLoad: Observable<Bool>
    }
    
    struct Output {
        let remainTime: Observable<Int>
        let buttonState: Observable<ButtonStyleState>
        let sentAuthCode: Observable<Void>
        let makeRootMainViewController: Observable<Void>
        let pushNicknameViewControoler: Observable<Void>
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
                input.viewDidLoad.filter { $0 }.mapToVoid()
            )
            .flatMap(firebaseAPI.verifyPhoneNumber)
            .mapToVoid()
            .debug()
        
        // Validation
        let buttonState: Observable<ButtonStyleState> = authCode
            .map(validate)
            .map { $0 ? .fill : .disable }
            
        // check deadline
        input.submitButtonTap
            .withLatestFrom(remainTime)
            .filter { $0 <= 0 }
            .subscribe(onNext: { [unowned self] _ in
                self.error.accept(AuthCodeError.authCodeExpired)
            })
            .disposed(by: disposeBag)
        
        // check isUser
        let idtoken = input.submitButtonTap
            .withLatestFrom(remainTime)
            .filter { $0 > 0 }
            .withLatestFrom(authCode.asObservable())
            .flatMapLatest{ [unowned self] in
                self.firebaseAPI.credential(verificationCode: $0)
                    .asObservable()
                    .materialize()
            }
            .share()
        idtoken.errors()
            .bind(to: self.error)
            .disposed(by: disposeBag)
        
        let isUser = idtoken.elements()
            .flatMapLatest { [unowned self] _ in
                self.authAPI.isUser()
                    .asObservable()
                    .materialize()
            }
            .share()
        
        isUser.errors()
            .bind(to: self.error)
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
            sentAuthCode: sendAuthCode,
            makeRootMainViewController: makeRootMainViewController,
            pushNicknameViewControoler: pushNicknameViewControoler
        )
    }
    
    func validate(authCode: String) -> Bool {
        authCode.count == 6
    }
}
