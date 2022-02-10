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
    static let shared = AuthAPI()
    private init() {}
    
    let provider = MoyaProvider<AuthTarget>()
    
    func isUser() -> Single<Bool> {
        return provider.rx.request(.isUser)
            .map { response in
                switch response.statusCode {
                case 200:
                    return true
                case 401:
                    throw APIError.firebaseTokenError
                case 406:
                    return false
                case 500:
                    throw APIError.serverError
                case 501:
                    throw APIError.clientError
                default:
                    throw APIError.undefinedError(statusCode: response.statusCode)
                }
            }
        }
    
    func getUser() -> Single<User> {
        return provider.rx.request(.isUser)
            .map { response in
                switch response.statusCode {
                case 200:
                    return try JSONDecoder().decode(User.self, from: response.data)
                case 401:
                    throw APIError.firebaseTokenError
                case 406:
                    throw APIError.undefinedUser
                default:
                    throw APIError.undefinedError(statusCode: response.statusCode)
                }
            }
    }
    
    func signUp(
        phoneNumber: String = SesacUserDefaults.phoneNumber,
        FCMtoken: String = SesacUserDefaults.FCMtoken,
        nick: String = SesacUserDefaults.nick,
        birth: Date = SesacUserDefaults.birth,
        email: String = SesacUserDefaults.email,
        gender: Int = SesacUserDefaults.gender
    ) -> Single<Void> {
        
        let phoneNumber = "+82\(phoneNumber.decimalFilteredString.dropFirst())"
        return provider.rx.request(.signUp(
            phoneNumber: phoneNumber, FCMToken: FCMtoken, nick: nick,
            birth: birth, email: email, gender: gender)
        )
            .map { response in
                switch response.statusCode {
                case 200:
                    return ()
                case 201:
                    throw APIError.already
                case 202:
                    throw APIError.invalidNickname
                case 401:
                    throw APIError.firebaseTokenError
                case 500:
                    throw APIError.serverError
                case 501:
                    throw APIError.clientError
                default:
                    throw APIError.undefinedError(statusCode: response.statusCode)
                }
            }
    }
    
    func withDraw() -> Single<Void> {
        return provider.rx.request(.withdraw)
            .map { response in
                switch response.statusCode {
                case 200:
                    return ()
                case 401:
                    throw APIError.firebaseTokenError
                case 406:
                    throw APIError.already
                case 500:
                    throw APIError.serverError
                default:
                    throw APIError.undefinedError(statusCode: response.statusCode)
                }
            }
    }
    
    func updateUser(
        gender: Int,
        hobby: String,
        searchable: Int,
        ageMin: Int,
        ageMax: Int
    ) -> Single<Void> {
        return provider.rx.request(.updateUser(gender: gender, hobby: hobby, searchable: searchable, ageMin: ageMin, ageMax: ageMax))
            .map { response in
                switch response.statusCode {
                case 200:
                    return ()
                case 401:
                    throw APIError.firebaseTokenError
                case 406:
                    throw APIError.undefinedUser
                case 500:
                    throw APIError.serverError
                case 501:
                    throw APIError.clientError
                default:
                    throw APIError.undefinedError(statusCode: response.statusCode)
                }
            }
    }
}
