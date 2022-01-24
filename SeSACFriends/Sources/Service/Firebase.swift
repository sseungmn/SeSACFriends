//
//  Firebase.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/23.
//

import Foundation

import FirebaseAuth
import RxSwift
import RxCocoa

class Firebase {
    static let shared = Firebase()
    
    func verifyPhoneNumber() -> Single<String> {
        let phoneNumber = AuthUserDefaults.phoneNumber
        return Single<String>.create { single in
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    guard let verificationID = verificationID else {
                        single(.failure(VerificationError.fail))
                        return
                    }
                    single(.success(verificationID))
                }
            return Disposables.create()
        }
    }
    
    func credential(verificationCode: String) -> Observable<Result<Bool, AuthCodeError>> {
        return Observable<Result<Bool, AuthCodeError>>.create { observer in
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: AuthUserDefaults.verificaitonID,
                verificationCode: verificationCode
            )
            
            Auth.auth().signIn(with: credential) { _, error in
                guard error == nil else {
                    print("invalidCode")
                    observer.onNext(.failure(.invalidCode))
                    return
                }
                Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    guard error == nil else {
                        print("idtokenError")
                        observer.onNext(.failure(.idtokenError))
                        return
                    }
                    if let idToken = idToken {
                        AuthUserDefaults.idtoken = idToken
                        observer.onNext(.success(true))
                    }
                }
            }
            return Disposables.create()
        }
    }
}
