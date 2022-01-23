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
import RxAlamofire

class Firebase {
    static let shared = Firebase()
    
    func verifyPhoneNumber(phoneNumber: String) -> Single<String> {
        debug(title: "phoneNumber", phoneNumber)
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
    
    func credential(verificationCode: String) -> Single<String?> {
        return Single<String?>.create { single in
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")!
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: verificationCode
            )
            
            Auth.auth().signIn(with: credential) { _, error in
                guard error == nil else {
                    single(.failure(AuthCodeError.invalidCode))
                    return
                }
            }
            Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                guard error == nil else {
                    single(.failure(AuthCodeError.idtokenError))
                    return
                }
                if let idToken = idToken {
                    single(.success(idToken))
                }
            }
            return Disposables.create()
        }
    }
}
