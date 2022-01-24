//
//  AuthAPI.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/24.
//

import Foundation

import Moya
import RxSwift

class AuthAPI {
    static var shared = AuthAPI()
    
    let provider = MoyaProvider<AuthTarget>()
    
    func isUser() -> Single<Bool> {
        return Single<Bool>.create { single in
            self.provider.rx.request(.isUser)
                .retry(2)
                .asObservable()
                .map { response in
                    switch response.statusCode {
                    case 200:
                        single(.success(true))
                    case 201:
                        single(.success(false))
                    case 401:
                        single(.failure(APIError.firebaseTokenExpired))
                    case 500:
                        single(.failure(APIError.severError))
                    case 501:
                        single(.failure(APIError.clientError))
                    default:
                        single(.failure(APIError.undefinedError))
                    }
                }
            return Disposables.create()
        }
        
//        func singup() -> Single<Void> {
//            let phoneNumber = AuthUserDefaults.phoneNumber
//            let FCMToken = AuthUserDefaults.FCMToken
//            let nick = AuthUserDefaults.nick
//            let birth = AuthUserDefaults.birth
//            let email = AuthUserDefaults.email
//            let gender = AuthUserDefaults.gender
//        }
    }
}
