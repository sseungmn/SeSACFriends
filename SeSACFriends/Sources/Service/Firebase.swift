//
//  Firebase.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/23.
//

import Foundation

import FirebaseAuth
import FirebaseMessaging
import RxSwift
import RxCocoa

class Firebase {
    static let shared = Firebase()
    private init() {}
    
    func verifyPhoneNumber(phoneNumber: String = SesacUserDefaults.phoneNumber) -> Single<String> {
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
                withVerificationID: SesacUserDefaults.verificaitonID,
                verificationCode: verificationCode
            )
            
            Auth.auth().signIn(with: credential) { _, error in
                guard error == nil else {
                    single(.failure(AuthCodeError.invalidCode))
                    return
                }
                Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    guard error == nil else {
                        single(.failure(AuthCodeError.idtokenError))
                        return
                    }
                    if let idToken = idToken {
                        SesacUserDefaults.idtoken = idToken
                        single(.success(()))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func idToken() -> Single<Void> {
        return Single<Void>.create { single in
            if let currentUser = Auth.auth().currentUser {
                currentUser.getIDTokenForcingRefresh(true) { idToken, error in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    if let idToken = idToken {
                        SesacUserDefaults.idtoken = idToken
                        single(.success(()))
                    }
                }
            } else {
                single(.failure(APIError.undefinedError()))
            }
            return Disposables.create()
        }
    }
    
    @discardableResult
    func FCMtoken() -> Single<Void> {
        return Single<Void>.create { single in
            Messaging.messaging().token { FCMtoken, error in
                if let error = error {
                    debug(title: "Error fetching FCM registration token", "\(error)")
                    single(.failure(error))
                } else if let FCMtoken = FCMtoken {
                    debug(title: "Firebase fetching FCM registration token", String(describing: FCMtoken))
                    SesacUserDefaults.FCMtoken = FCMtoken
                    single(.success(()))
                }
            }
            return Disposables.create()
        }
    }
}
