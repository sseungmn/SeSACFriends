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
    
    func verifyPhoneNumber(phoneNumber: String = AuthUserDefaults.phoneNumber) -> Single<String> {
        let phoneNumber = "+82\(phoneNumber.decimalFilteredString.dropFirst())"
        print(phoneNumber)
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
    
    func credential(verificationCode: String) -> Single<Void> {
        return Single<Void>.create { single in
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: AuthUserDefaults.verificaitonID,
                verificationCode: verificationCode
            )
            
            Auth.auth().signIn(with: credential) { _, error in
                guard error == nil else {
                    print("invalidCode")
                    single(.failure(AuthCodeError.invalidCode))
                    return
                }
                Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    guard error == nil else {
                        print("idtokenError")
                        single(.failure(AuthCodeError.idtokenError))
                        return
                    }
                    if let idToken = idToken {
                        AuthUserDefaults.idtoken = idToken
                        single(.success(()))
                    }
                }
            }
            return Disposables.create()
        }
    }
}
