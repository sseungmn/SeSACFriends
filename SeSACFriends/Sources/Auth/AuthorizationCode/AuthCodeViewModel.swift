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
    
    let timeLimit = 5
    let setTimer = BehaviorRelay<Void>(value: ())
    
    let error = PublishRelay<AuthCodeError>()
    
    struct Input {
        let inputText: ControlProperty<String>
        let resendButtonTap: ControlEvent<Void>
        let submitButtonTap: Observable<Void>
    }
    
    struct Output {
        let remainTime: Observable<Int>
        let buttonState: Observable<ButtonStyleState>
        let isUser: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        // Timer
        let remainTime = setTimer
            .flatMapLatest { Driver<Int>.timer(.seconds(0), period: .seconds(1)) }
            .map { self.timeLimit - $0 }
            .filter { $0 >= 0 }
            .share()
        
        input.resendButtonTap.debug()
            .bind(to: setTimer)
            .disposed(by: disposeBag)
        
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
        let isUser = input.submitButtonTap
            .withLatestFrom(remainTime)
            .filter { $0 > 0 }
            .withLatestFrom(authCode.asObservable())
            .flatMap(credential)
            .flatMap(isUser)
        
        return Output(
            remainTime: remainTime,
            buttonState: buttonState,
            isUser: isUser
        )
    }
    
    func credential(verificationCode: String) -> Observable<String> {
        return Observable<String>.create { observer in
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")!
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: verificationCode
            )

            Auth.auth().signIn(with: credential) { _, error in
                if error != nil {
                    self.error.accept(AuthCodeError.invalidCode)
                    return
                }
                Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if error != nil {
                        self.error.accept(AuthCodeError.idtokenError)
                        return
                    }
                    if let idToken = idToken {
                        observer.onNext(idToken)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func isUser(idToken: String) -> Observable<Bool> {
        return request(.get, "http://test.monocoding.com:353484/user",
                       headers: ["idtoken": idToken])
            .response()
            .map { response in
                switch response.statusCode {
                case 200:
                    return true
                case 201:
                    return false
                case 401:
                    throw APIError.firebaseTokenExpired
                case 500:
                    throw APIError.severError
                case 501:
                    throw APIError.clientError
                default:
                    throw APIError.undefinedError
                }
            }
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
