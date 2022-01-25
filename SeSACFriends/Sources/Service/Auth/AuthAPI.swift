//
//  AuthAPI.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/24.
//

import Foundation

import Moya
import RxSwift

enum AuthCodeError: Error {
    case authCodeExpired
    case idtokenError
    case invalidCode
}

class AuthAPI {
    static var shared = AuthAPI()
    
    let provider = MoyaProvider<AuthTarget>()
    
    func isUser() -> Single<Bool> {
        return provider.rx.request(.isUser)
            .map { response in
                switch response.statusCode {
                case 200:
                    return true
                case 201:
                    return false
                case 401:
                    throw APIError.firebaseTokenError
                default:
                    throw APIError.undefinedError
                }
            }
        }
    
    func signUp() -> Single<Bool> {
        return provider.rx.request(.signUp)
            .map { response in
                switch response.statusCode {
                case 200:
                    return true
                case 201:
                    throw APIError.already
                case 202:
                    throw APIError.invalidNickname
                case 401:
                    throw APIError.firebaseTokenError
                case 500:
                    throw APIError.severError
                case 501:
                    throw APIError.clientError
                default:
                    throw APIError.undefinedError
                }
            }
    }
    
    func withDraw() -> Single<Bool> {
        return provider.rx.request(.withdraw)
            .map { response in
                switch response.statusCode {
                case 200:
                    return true
                case 401:
                    throw APIError.firebaseTokenError
                case 406:
                    throw APIError.already
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
